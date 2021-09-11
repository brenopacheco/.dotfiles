local dap_install = require("dap-install");

dap_install.setup({
	installation_path = vim.env.HOME .. "/.config/nvim/dapinstall/",
	verbosely_call_debuggers = true,
})

dap_install.config("jsnode_dbg", {});

