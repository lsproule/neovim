local M = {}

local heading = {
	type = "text",
	val = nil,
	opts = {
		position = "center",
		hl = "AlphaHeading",
	},
}

local buttons = {
	type = "group",
	val = nil,
	opts = {
		position = "center",
		spacing = 1,
	},
}

local extras = {
	type = "text",
	val = string.format("  Loaded %d runtime paths.", #vim.api.nvim_list_runtime_paths()),
	opts = {
		position = "center",
		hl = "AlphaLoaded",
	},
}

local footing = {
	type = "text",
	val = "use space + ←↑→ keys to move around",
	opts = {
		position = "center",
		hl = "AlphaFooting",
	},
}

M.config = {
	layout = {
		{ type = "padding", val = 9 },
		heading,
		{ type = "padding", val = 2 },
		footing,
		{ type = "padding", val = 1 },
		buttons,
		{ type = "padding", val = 1 },
		-- extras,
	},
	opts = { margin = 15 },
}

function M.autocmd()
	vim.api.nvim_create_autocmd("FileType", {
		callback = function()
			if vim.bo.filetype == "alpha" then
				vim.keymap.set("n", "q", function()
					require("alpha").start(false)
				end, { silent = true, buffer = vim.api.nvim_get_current_buf() })
			end
		end,
	})
end

return M
