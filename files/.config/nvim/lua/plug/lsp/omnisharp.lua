-- local pid = vim.fn.getpid()
-- local omnisharp_bin = vim.env.HOME .. "/.pkgs/omnisharp/bin/mono"
-- local M = {
--     cmd = { omnisharp_bin },
--     on_attach = require('keymap').register_lsp,
-- }

-- return M
--
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport =
{
	properties =
	{
		'documentation',
		'detail',
		'additionalTextEdits',
	}
}

-- Omnisharp exclusion pattterns
local omnisharp_exclusion_patterns =
{
	'**/node_modules/**/*',
	'**/bin/**/*',
	'**/obj/**/*',
	'/tmp/**/*'
}

local M = {
		cmd = {'/usr/bin/omnisharp', '--languageserver', '--hostPID', tostring(vim.loop.os_getpid())},
    on_attach = require('keymap').register_lsp,
		filetypes = {'cache', 'cs', 'csproj', 'dll', 'nuget', 'props', 'sln', 'targets'},
		log_level = 2,
		settings =
		{
			FileOptions =
			{
				ExcludeSearchPatterns = omnisharp_exclusion_patterns,
				SystemExcludeSearchPatterns = omnisharp_exclusion_patterns,
			},
			FormattingOptions =
			{
				EnableEditorConfigSupport = true,
			},
			ImplementTypeOptions =
			{
				InsertionBehavior = 'WithOtherMembersOfTheSameKind',
				PropertyGenerationBehavior = 'PreferAutoProperties',
			},
			RenameOptions =
			{
				RenameInComments = true,
				RenameInStrings  = true,
				RenameOverloads  = true,
			},
			RoslynExtensionsOptions =
			{
				EnableAnalyzersSupport = true,
				EnableDecompilationSupport = true,
				LocationPaths =
				{
					"~/.omnisharp/Roslynator/src/Analyzers.CodeFixes/bin/Debug/netstandard2.0",
					"~/.omnisharp/Roslynator/src/Analyzers/bin/Debug/netstandard2.0",
					"~/.omnisharp/Roslynator/src/CodeAnalysis.Analyzers.CodeFixes/bin/Debug/netstandard2.0",
					"~/.omnisharp/Roslynator/src/CodeAnalysis.Analyzers/bin/Debug/netstandard2.0",
					"~/.omnisharp/Roslynator/src/CodeFixes/bin/Debug/netstandard2.0",
					"~/.omnisharp/Roslynator/src/CommandLine/bin/Debug/netstandard2.0",
					"~/.omnisharp/Roslynator/src/Common/bin/Debug/netstandard2.0",
					"~/.omnisharp/Roslynator/src/Core/bin/Debug/netstandard2.0",
					"~/.omnisharp/Roslynator/src/CSharp.Workspaces/bin/Debug/netstandard2.0",
					"~/.omnisharp/Roslynator/src/CSharp/bin/Debug/netstandard2.0",
					"~/.omnisharp/Roslynator/src/Documentation/bin/Debug/netstandard2.0",
					"~/.omnisharp/Roslynator/src/Formatting.Analyzers.CodeFixes/bin/Debug/netstandard2.0",
					"~/.omnisharp/Roslynator/src/Formatting.Analyzers/bin/Debug/netstandard2.0",
					"~/.omnisharp/Roslynator/src/Refactorings/bin/Debug/netstandard2.0",
					"~/.omnisharp/Roslynator/src/Workspaces.Common/bin/Debug/netstandard2.0",
					"~/.omnisharp/Roslynator/src/Workspaces.Core/bin/Debug/netstandard2.0",
				},
			},
		},
	}

return M
