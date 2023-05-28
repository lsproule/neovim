local M = {}

M._state = {
	x = { "HOME", "EXPERIENCE" },
	y = { "ABOUT", "REVIEWS", "SCHOOL" },
	current = { x = 1, y = 1 },
}

M._config = {
	x = {
		require("scratch.alpha.pages.home"),
		require("scratch.alpha.pages.experience"),
	},
	y = {
		require("scratch.alpha.pages.about"),
		require("scratch.alpha.pages.reviews"),
		require("scratch.alpha.pages.school"),
	},
}

local alpha = require("alpha")
local util = require("scratch.alpha.util")
local generate = require("scratch.alpha.generate")

function M.make(button_label_map, logo, open)
	logo = vim.F.if_nil(logo, "OCTOPI")

	generate.config.layout[6].val = util.button_map(unpack(button_label_map))
	generate.config.layout[2].val = util.get_logo(logo)
	alpha.setup(generate.config)
	if open then
		vim.cmd.Alpha()
	end
end

local function opened(run_callback)
	local bufinfo = vim.fn.getbufinfo()
	for _, inf in ipairs(bufinfo) do
		local buffer = inf.bufnr
		local filetype = vim.api.nvim_buf_get_option(buffer, "filetype")
		if filetype == "alpha" and inf.hidden == 0 then
			run_callback()
		end
	end
end

local function move(direction, offset, on_exit)
	assert(direction and type(direction) == "string")
	assert(direction == "x" or direction == "y")

	M._state.current.direction = direction
	M._state.current[direction] = M._state.current[direction] + offset
	-- vim.notify("STT " .. vim.inspect(M._state.current[direction]))

	if M._state.current[direction] > #M._state[direction] then
		M._state.current[direction] = 1
	end
	if M._state.current[direction] < 1 then
		M._state.current[direction] = #M._state[direction]
	end

	-- vim.notify("END ".. vim.inspect(M._state.current[direction]))
	on_exit(M._config[direction][M._state.current[direction]], M._state, M._config)
end

function M.commands()
	vim.api.nvim_create_user_command("CommandLocation", function()
		vim.notify(vim.inspect(M._state))
	end, {})

	vim.api.nvim_create_user_command("CommandHome", function()
		opened(vim.cmd.Alpha)
		local home_config = M._config.x[1]
		require("scratch.alpha").make(home_config[1], home_config[2], home_config[3])
	end, {})

	vim.api.nvim_create_user_command("CommandHome", function()
		opened(vim.cmd.Alpha)
		local home_config = M._config.x[1]
		require("scratch.alpha").make(home_config[1], home_config[2], home_config[3])
	end, {})

	vim.api.nvim_create_user_command("CommandHome", function()
		opened(vim.cmd.Alpha)
		local home_config = M._config.x[1]
		require("scratch.alpha").make(home_config[1], home_config[2], home_config[3])
	end, {})

	vim.api.nvim_create_user_command("CommandUp", function()
		move("y", 1, function(new_config, _, _)
			opened(vim.cmd.Alpha)
			require("scratch.alpha").make(new_config[1], new_config[2], new_config[3])
		end)
	end, {})

	vim.api.nvim_create_user_command("CommandDown", function()
		move("y", -1, function(new_config, _, _)
			opened(vim.cmd.Alpha)
			require("scratch.alpha").make(new_config[1], new_config[2], new_config[3])
		end)
	end, {})

	vim.api.nvim_create_user_command("Popup", function(text)
		local Popup = require("nui.popup")
		local event = require("nui.utils.autocmd").event
		local popup = Popup({
			enter = true,
			focusable = true,
			border = {
				style = "rounded",
			},
			position = "50%",
			size = {
				width = "80%",
				height = "60%",
			},
			win_options = {
				winblend = 0,
				winhighlight = "Normal:Normal,FloatBorder:FloatBorder,",
			},
		})
		popup:mount()
		vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, { text.args })
		popup:on(event.BufLeave, function()
			popup:unmount()
		end)
		vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, { text.args })
	end, { nargs = "?" })

	vim.api.nvim_create_user_command("CommandLeft", function()
		move("x", -1, function(new_config, _, _)
			opened(vim.cmd.Alpha)
			require("scratch.alpha").make(new_config[1], new_config[2], new_config[3])
		end)
	end, {})

	vim.api.nvim_create_user_command("CommandRight", function()
		move("x", 1, function(new_config, _, _)
			opened(vim.cmd.Alpha)
			require("scratch.alpha").make(new_config[1], new_config[2], new_config[3])
		end)
	end, {})
end

return M
