local gitlinker = require("gitlinker.hosts")

local function get_azure_type_url(url_data)
  local colStart = vim.fn.getpos("'<")[3]
  local colEnd = vim.fn.getpos("'>")[3]

  if colStart > 999 then colStart = string.len(vim.fn.getline(url_data.lstart)) + 1 end
  if colEnd > 999 then colEnd = string.len(vim.fn.getline(url_data.lend)) + 1 end

  local url = 'https://'
    .. string.gsub(url_data.host, 'ssh%.', '')
    .. string.gsub(string.gsub(url_data.repo, "^v%d+", ""),  "(.*)/(.+)$", "%1/_git/%2")
    .. "?path=%2F" .. string.gsub(url_data.file, "/", "%%2F")
    .. "&version=GC" .. url_data.rev -- commit
    .. "&line=" .. url_data.lstart
    .. "&lineEnd=" .. (url_data.lend or url_data.lstart)
    .. "&lineStartColumn=" .. colStart
    .. "&lineEndColumn=" .. colEnd
    .. "&lineStyle=plain"
    .. "&_a=contents"
    vim.fn['setreg']('+', url)
    return url
end

require"gitlinker".setup({
  opts = {
    remote = nil,
    add_current_line_on_normal_mode = true,
    action_callback = require"gitlinker.actions".copy_to_clipboard,
    print_url = true,
  },
  callbacks = {
        ["github.com"]           = gitlinker.get_github_type_url,
        ["gitlab.com"]           = gitlinker.get_gitlab_type_url,
        ["try.gitea.io"]         = gitlinker.get_gitea_type_url,
        ["codeberg.org"]         = gitlinker.get_gitea_type_url,
        ["bitbucket.org"]        = gitlinker.get_bitbucket_type_url,
        ["try.gogs.io"]          = gitlinker.get_gogs_type_url,
        ["git.sr.ht"]            = gitlinker.get_srht_type_url,
        ["git.launchpad.net"]    = gitlinker.get_launchpad_type_url,
        ["repo.or.cz"]           = gitlinker.get_repoorcz_type_url,
        ["git.kernel.org"]       = gitlinker.get_cgit_type_url,
        ["git.savannah.gnu.org"] = gitlinker.get_cgit_type_url,
        ["dev.azure.com"]        = get_azure_type_url
  },
  mappings = nil
})
