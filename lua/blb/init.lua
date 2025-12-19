local M = {}

M.config = {}
M.config.translation = "NIV"

function M._get_user_selection()
	local buf = 0

	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")

	if start_pos[2] == 0 or end_pos[2] == 0 then
		vim.notify("BLB requires a visual selection", vim.log.levels.ERROR)
		return
	end

	local start_row = start_pos[2] - 1
	local start_col = start_pos[3] - 1
	local end_row = end_pos[2] - 1
	local end_col = end_pos[3]

	local lines = vim.api.nvim_buf_get_text(buf, start_row, start_col, end_row, end_col, {})

	local text = table.concat(lines, "\n")
	return text
end

function M._get_end_translation(text)
	local rtext = string.reverse(text)
	local last_word_index = string.find(rtext, " ")

	if not last_word_index then
		return nil, nil
	end

	last_word_index = string.len(text) - last_word_index + 2
	local translation = string.sub(text, last_word_index, -1)

	if string.find(translation, "%d") then
		return nil, nil
	end

	if translation:find("%l") then
		return nil, nil
	end

	return string.sub(text, 1, last_word_index - 2), translation
end

function M._url_encode(str)
	return (str:gsub("([^%w%-_%.~])", function(c)
		return string.format("%%%02X", string.byte(c))
	end))
end

function M._open_blb(term, translation)
	local formatted_term = M._url_encode(term)
	local url = "https://www.blueletterbible.org/search/preSearch.cfm?Criteria="
		.. formatted_term
		.. "&t="
		.. translation
	vim.fn.jobstart({ "xdg-open", url }, { detach = true })
end

vim.api.nvim_create_user_command("BLB", function()
	local text = M._get_user_selection()

	if not text then
		return
	end

	local new_text, translation = M._get_end_translation(text)
	if translation then
		text = new_text
	else
		translation = M.config.translation
	end
	M._open_blb(text, translation)
end, {})

return M
