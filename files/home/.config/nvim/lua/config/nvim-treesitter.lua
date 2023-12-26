local supported = {
  'bash', 'c', 'clojure', 'cmake', 'comment', 'commonlisp', 'cpp', 'c_sharp', 'css', 'dart', 'diff', 'dockerfile', 'dot',
  'elixir', 'elm', 'erlang', 'fennel', 'gitattributes', 'gitcommit', 'git_config', 'gitignore', 'git_rebase', 'go',
  'gomod', 'gosum', 'graphql', 'groovy', 'html', 'http', 'ini', 'java', 'javascript', 'jq', 'jsdoc', 'json', 'json5',
  'julia', 'kotlin', 'latex', 'lua', 'luadoc', 'luau', 'make', 'markdown', 'markdown_inline', 'mermaid', 'meson', 'ninja',
  'nix', 'norg', 'ocaml', 'ocaml_interface', 'odin', 'org', 'passwd', 'perl', 'php', 'prisma', 'proto', 'pug', 'python',
  'r', 'racket', 'regex', 'rst', 'ruby', 'rust', 'scala', 'scheme', 'scss', 'solidity', 'sql', 'svelte', 'sxhkdrc',
  'terraform', 'toml', 'tsx', 'twig', 'typescript', 'v', 'vala', 'vim', 'vimdoc', 'vue', 'yaml', 'zig',
}

require('nvim-treesitter.configs').setup({
	ignore_install = {},
	sync_install = false,
	auto_install = true,
	modules = {},
	ensure_installed = supported,
	indent = { enable = true },
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = { 'org', 'markdown' },
	},
	incremental_selection = { enable = false },
	textobjects = {
		select = {
			enable = true,
			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			keymaps = {
				['af'] = '@function.outer',
				['if'] = '@function.inner',
				['ac'] = '@class.outer',
				['ic'] = '@class.inner',
			},
		},
	},
	playground = {
		enable = true,
	},
})

vim.print(vim.treesitter.language.add('bash', {
	path = require('nvim-treesitter.configs').get_parser_install_dir()
		.. '/bash.so',
}))