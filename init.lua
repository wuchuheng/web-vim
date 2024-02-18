if vim.loader and vim.fn.has("nvim-0.9.1") == 1 then
	vim.loader.enable()
end

for _, source in ipairs({
	"astronvim.bootstrap",
	"astronvim.options",
	"astronvim.lazy",
	"astronvim.autocmds",
	"astronvim.mappings",

}) do
	local status_ok, rfault = pcall(require, source)
	if not status_ok then
		vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault)
	end
end

if astronvim.default_colorscheme then
	if not pcall(vim.cmd.colorscheme, astronvim.default_colorscheme) then
		require("astronvim.utils").notify(
			("Error setting up colorscheme: `%s`"):format(astronvim.default_colorscheme),
			vim.log.levels.ERROR
		)
	end
end

require("astronvim.utils").conditional_func(astronvim.user_opts("polish", nil, false), true)


local dap = require("dap")
dap.adapters.node2 = {
	type = "executable",
	command = "node",
	args = {
		os.getenv("XDG_DATA_HOME") .. "nvim/mason/packages/node-debug2-adapter/out/src/nodeDebug.js",
	},
}

dap.configurations.javascript = {
	{
		name = "Launch",
		type = "node2",
		request = "launch",
		program = "${file}",
		cwd = vim.fn.getcwd(),
		sourceMaps = true,
		protocol = "inspector",
		console = "integratedTerminal",
	},
}
