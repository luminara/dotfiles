return {
	"kawre/leetcode.nvim",
	build = ":TSUpdate html",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	opts = {
		---@type lc.lang
		lang = "golang",
	},
	config = function(_, opts)
		require("leetcode").setup(opts)

		local map = vim.keymap.set
		map("n", "<leader>lq", "<cmd>Leet desc<cr>", { desc = "LeetCode: Toggle Question / Code" })
		map("n", "<leader>ls", "<cmd>Leet submit<cr>", { desc = "LeetCode: Submit Solution" })
		map("n", "<leader>lr", "<cmd>Leet run<cr>", { desc = "LeetCode: Run Tests" })
		map("n", "<leader>li", "<cmd>Leet info<cr>", { desc = "LeetCode: Show Problem Info" })
		map("n", "<leader>lc", "<cmd>Leet reset<cr>", { desc = "LeetCode: Reset Code" })
	end,
}
