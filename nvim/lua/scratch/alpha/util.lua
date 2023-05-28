local M = {}
local logos = require("scratch.alpha.logos")

function M.Popup(title, text)
	local Popup = require("nui.popup")
	local event = require("nui.utils.autocmd").event
	local popup = Popup({
		enter = true,
		focusable = true,
		border = {
			style = "rounded",
			text = {
				top = title,
				top_align = "center",
			},
		},
		position = "50%",
		size = {
			width = "80%",
			height = "60%",
		},
		win_options = {
			winblend = 0,
			winhighlight = "Normal:CursorColumn,FloatBorder:FloatBorder",
		},
	})
	popup:mount()
	vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, text)
	vim.api.nvim_buf_set_option(popup.bufnr, "modifiable", false)

	popup:on(event.BufLeave, function()
		popup:unmount()
	end)
end

function M.generate_button(callback, opts)
	local set = {
		type = "button",
		on_press = callback,
		val = ("%s%s"):format((" "):rep(opts.spacing or 2), opts.label.value),
		opts = {
			position = vim.F.if_nil(opts.align, "center"),
			shortcut = vim.F.if_nil(opts.shortcut.value, "DUMMY"),
			cursor = vim.F.if_nil(opts.cursor, 5),
			width = vim.F.if_nil(opts.width, 25),
			align_shortcut = vim.F.if_nil(opts.shortcut.align, "center"),
			hl_shortcut = vim.F.if_nil(opts.shortcut.hl, "AlphaKeyPrefix"),
			hl = {},
		},
	}

	if opts.shortcut.before then
		set.opts.shortcut = opts.shortcut.before .. set.opts.shortcut
	else
		set.opts.shortcut = " " .. set.opts.shortcut
	end

	if opts.shortcut.after then
		set.opts.shortcut = set.opts.shortcut .. opts.shortcut.after
	else
		set.opts.shortcut = set.opts.shortcut .. " "
	end

	-- local icon_length = opts.icon.value:len()
	local label_length = opts.label.value:len()
	-- set.opts.hl = {
	--   { opts.icon.hl,  1,                          icon_length },
	--   { opts.label.hl, icon_length + opts.spacing, icon_length + (opts.spacing or 2) + label_length },
	-- }
	return set
end

function M.button_map(labels, actions)
	assert(#labels == #actions)
	local index = #labels
	local mapped = {}
	while index > 0 do
		local current_label = labels[index]
		local current_action = actions[index]
		table.insert(
			mapped,
			M.generate_button(current_action, {
				width = 25,
				cursor = 5,
				align = "center",
				spacing = 2,
				shortcut = { value = " T ", align = "right", hl = "AlphaKeyPrefix", lead = " ", trail = " " },
				label = { value = current_label, hl = "MoreMsg" },
				-- icon = { value = " ", hl = "MsgSeparator" },
			})
		)
		index = index - 1
	end
	return mapped
end

function M.get_logo(logo)
	if type(logo) == "string" then
		assert(logos[logo])
		return logos[logo]
	end
	return logo
end

return M
