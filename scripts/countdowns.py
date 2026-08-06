#!/usr/bin/env python3
"""Waybar 'days until' widget.

Merges local countdowns (~/.config/waybar/countdowns.json) with upcoming
Google Calendar events into one sorted list, and prints Waybar's
custom-module JSON: {"text": ..., "tooltip": ...}.

--- First-time Google Calendar setup ---
1. https://console.cloud.google.com/ -> create a project -> enable the
   "Google Calendar API" (APIs & Services -> Library).
2. APIs & Services -> Credentials -> Create Credentials -> OAuth client ID
   -> Application type: Desktop app. Download the JSON and save it as:
     $CONFIG_DIR/gcal_credentials.json
3. Install deps:
     pip install --user google-auth google-auth-oauthlib google-api-python-client
4. Run this once BY HAND from a terminal (not from Waybar) to do the
   browser consent flow:
     ./countdowns.py --auth
   This stores a refresh token at ~/.config/waybar/gcal_token.json. After
   that, Waybar can call the script with no browser popup — the token
   refreshes itself silently.

If the Google deps aren't installed, or auth hasn't been set up yet, the
script just falls back to local-only countdowns (with a note on stderr).

If a live fetch fails (e.g. no internet), the script falls back to the
last cached events on disk, even if that cache is older than the normal
TTL, so the widget keeps showing calendar events while offline.
"""

import argparse
import json
import sys
from datetime import date, datetime, timedelta, timezone
from pathlib import Path

CONFIG_DIR = Path.home() / ".config" / "waybar" / "gcal"
COUNTDOWNS_FILE = CONFIG_DIR / "countdowns.json"
GCAL_CREDS_FILE = CONFIG_DIR / "gcal_credentials.json"
GCAL_TOKEN_FILE = CONFIG_DIR / "gcal_token.json"
GCAL_CACHE_FILE = CONFIG_DIR / "gcal_cache.json"
GCAL_CACHE_TTL = timedelta(minutes=5)
GCAL_LOOKAHEAD_DAYS = 180
GCAL_SCOPES = ["https://www.googleapis.com/auth/calendar.readonly"]


def load_local_events():
    if not COUNTDOWNS_FILE.exists():
        return []
    with COUNTDOWNS_FILE.open() as f:
        raw = json.load(f)
    return [{"title": e["title"], "date": e["date"]} for e in raw]


def get_google_creds(interactive=False):
    """Load/refresh stored OAuth creds. Returns None if unavailable."""
    try:
        from google.auth.transport.requests import Request
        from google.oauth2.credentials import Credentials
        from google_auth_oauthlib.flow import InstalledAppFlow
    except ImportError:
        if interactive:
            print(
                "Missing deps: pip install --user google-auth google-auth-oauthlib google-api-python-client",
                file=sys.stderr,
            )
        return None

    creds = None
    if GCAL_TOKEN_FILE.exists():
        creds = Credentials.from_authorized_user_file(str(GCAL_TOKEN_FILE), GCAL_SCOPES)

    if creds and creds.expired and creds.refresh_token:
        try:
            creds.refresh(Request())
            GCAL_TOKEN_FILE.write_text(creds.to_json())
        except Exception as exc:
            print(f"gcal: token refresh failed: {exc}", file=sys.stderr)
            creds = None

    if not creds or not creds.valid:
        if not interactive:
            return None
        if not GCAL_CREDS_FILE.exists():
            print(
                f"gcal: missing {GCAL_CREDS_FILE} (download OAuth client JSON from Google Cloud Console first)",
                file=sys.stderr,
            )
            return None
        flow = InstalledAppFlow.from_client_secrets_file(
            str(GCAL_CREDS_FILE), GCAL_SCOPES
        )
        creds = flow.run_local_server(port=0)
        GCAL_TOKEN_FILE.write_text(creds.to_json())

    return creds


def _read_cache():
    """Return the cached cache dict ({"fetched_at": ..., "events": ...}),
    or None if it doesn't exist or is corrupt."""
    if not GCAL_CACHE_FILE.exists():
        return None
    try:
        return json.loads(GCAL_CACHE_FILE.read_text())
    except Exception:
        return None


def fetch_google_events():
    """Return upcoming Google Calendar events, via a short-lived local cache
    so Waybar's polling interval doesn't hit the API on every tick.

    If a fresh fetch isn't possible (no creds, refresh failure, network
    down, API error, etc.) but a cache file exists -- even a stale one --
    that stale cache is returned rather than an empty list.
    """
    cache = _read_cache()
    if cache is not None:
        try:
            fetched_at = datetime.fromisoformat(cache["fetched_at"])
            if datetime.now() - fetched_at < GCAL_CACHE_TTL:
                return cache["events"]
        except Exception:
            cache = None  # malformed cache contents -> treat as no cache

    creds = get_google_creds(interactive=False)
    if not creds:
        if cache is not None:
            print("gcal: no valid credentials, using stale cache", file=sys.stderr)
            return cache["events"]
        return []

    try:
        from googleapiclient.discovery import build

        service = build("calendar", "v3", credentials=creds)
        now = datetime.now(timezone.utc).isoformat()
        until = (
            datetime.now(timezone.utc) + timedelta(days=GCAL_LOOKAHEAD_DAYS)
        ).isoformat()
        result = (
            service.events()
            .list(
                calendarId="primary",
                timeMin=now,
                timeMax=until,
                singleEvents=True,
                orderBy="startTime",
                maxResults=50,
            )
            .execute()
        )
    except Exception as exc:
        print(f"gcal: fetch failed: {exc}", file=sys.stderr)
        if cache is not None:
            print("gcal: using stale cache", file=sys.stderr)
            return cache["events"]
        return []

    events = []
    for item in result.get("items", []):
        start = item.get("start", {})
        raw_date = start.get("date") or start.get("dateTime", "")[:10]
        if not raw_date:
            continue
        events.append(
            {
                "title": item.get("summary", "(no title)"),
                "date": raw_date,
            }
        )
    GCAL_CACHE_FILE.write_text(
        json.dumps({"fetched_at": datetime.now().isoformat(), "events": events})
    )
    return events


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--auth",
        action="store_true",
        help="Run interactive Google OAuth consent flow and exit.",
    )
    args = parser.parse_args()

    if args.auth:
        creds = get_google_creds(interactive=True)
        print(
            "Google Calendar auth OK." if creds else "Google Calendar auth failed.",
            file=sys.stderr,
        )
        return

    today = date.today()
    all_events = load_local_events() + fetch_google_events()

    upcoming = []
    for event in all_events:
        try:
            target = date.fromisoformat(event["date"])
        except ValueError:
            continue
        days = (target - today).days
        if days >= 0:
            upcoming.append({"title": event["title"], "days": days})

    upcoming.sort(key=lambda e: e["days"])

    if not upcoming:
        print(json.dumps({"text": "No events", "tooltip": ""}))
        return

    next_event = upcoming[0]
    tooltip = "\n".join(f"{e['days']}d: {e['title']}" for e in upcoming)
    print(
        json.dumps(
            {
                "text": f"{next_event['days']}d",
                "tooltip": tooltip,
            }
        )
    )


if __name__ == "__main__":
    main()
