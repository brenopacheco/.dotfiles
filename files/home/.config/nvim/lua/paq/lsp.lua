local lspconfig = require("lspconfig")
local utils = require("utils")

-- vim.lsp.set_log_level(vim.log.levels.OFF)
vim.lsp.set_log_level(vim.log.levels.ERROR)

lspconfig.omnisharp.setup(require("paq.lsp.omnisharp"))

local servers = {
  -- "csharp_ls",

	"ansiblels",
	"bashls",
	"clangd",
	-- "ccls",
	"cmake",
	"cssls",
	"dockerls",
	"dotls",
	"elixirls",
	"eslint",
	"gopls",
	"graphql",
	"helm_ls",
	"html",
	"jdtls",
	"jqls",
	"jsonls",
	"lua_ls",
	"marksman",
	-- 'omnisharp',
	"prismals",
	"pylyzer",
	"quick_lint_js",
	"rust_analyzer",
	"solargraph",
	"sqlls",
	"tailwindcss",
	-- "tsserver",
	"vimls",
	"yamlls",
	"svelte",
	-- "efm",
  "zls",
  "serve_d",
  "ocamllsp" -- fix root dir to allow non-git
}

-- enable snippets. we are interested in function call snippets
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
	properties = { "documentation", "detail", "additionalTextEdits" },
}
-- capabilities.textDocument.semanticTokensProvider = nil
-- capabilities.offsetEncoding = { "utf-8", "utf-16" }
capabilities.offsetEncoding = { "utf-16" }

for _, server in pairs(servers) do
	lspconfig[server].setup({
		on_attach = utils.lsp_attach,
		capabilities = capabilities,
		on_init = function(client, _)
			if client.server_capabilities then
				client.server_capabilities.documentFormattingProvider = false
				-- client.server_capabilities.semanticTokensProvider = false
				-- client.server_capabilities.semanticTokensProvider = false
			end
		end,
		settings = {
			["rust-analyzer"] = {
				diagnostics = {
					enable = true,
          experimental = {
            enable = true,
          }
				},
			},
			gopls = {
				completeUnimported = true,
				usePlaceholders = true,
				analyses = {
					unusedparams = true,
					fieldalignment = true,
					shadow = true,
					unusedwrite = true,
					unusedvariable = true,
					useany = true,
				},
			},
			documentFormatting = false,
			json = {
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
			yaml = {
				schemaStore = { enable = true },
			},
			Lua = {
				completion = {
					keywordSnippet = "Disable",
				},
				runtime = {
					version = "LuaJIT",
					path = vim.split(package.path, ";"),
				},
				diagnostics = {
					globals = { "vim", "love" },
					disable = { "lowercase-global", "unused-vararg" },
				},
				workspace = {
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
					},
				},
			},
		},
	})
end


-- -- custom diagnostic signs / remove underline
local signs = {
	Error = " ",
	Warning = " ",
	Hint = " ",
	Information = " ",
}
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
	virtual_text = true,
	signs = true,
	underline = true,
	update_in_insert = true,
	severity_sort = true,
})

-- Fix behavior of <C-]>
vim.lsp.handlers["textDocument/definition"] = function(_, result, ctx, config)
	if result == nil or vim.tbl_isempty(result) then
		print(ctx.method, "No location found")
		return nil
	end
	local client = vim.lsp.get_client_by_id(ctx.client_id)

	config = config or {}

	if vim.tbl_islist(result) then
		vim.lsp.util.jump_to_location(result[1], client.offset_encoding, config.reuse_win)

		if #result > 1 then
			vim.fn.setqflist({}, " ", {
				title = "LSP locations",
				items = vim.lsp.util.locations_to_items(result, client.offset_encoding),
			})
			vim.api.nvim_command("botright copen")
			vim.api.nvim_command("wincmd p") -- this is the added line
		end
	else
		vim.lsp.util.jump_to_location(result, client.offset_encoding, config.reuse_win)
	end
end
