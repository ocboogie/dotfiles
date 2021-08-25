local map_key = vim.api.nvim_set_keymap

local function map(modes, lhs, rhs, opts)
	local opts_bool = {}
	for opt in vim.gsplit(opts or "", " ") do
		if opt ~= "" then
			opts_bool[opt] = true
		end
	end
	opts_bool.noremap = opts_bool.noremap == nil and true or opts_bool.noremap

	for mode in vim.gsplit(modes, "") do
		map_key(mode, lhs, rhs, opts_bool)
	end
end

return { map = map }
