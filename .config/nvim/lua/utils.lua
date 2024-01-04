local M = {}

M.trim = function(s)
  return string.gsub(s, "[\r\n]", "")
end

M.split = function(str, pat)
  local t = {} -- NOTE: use {n = 0} in Lua-5.0
  local fpat = "(.-)" .. pat
  local last_end = 1
  local s, e, cap = str:find(fpat, 1)
  while s do
    if s ~= 1 or cap ~= "" then
      table.insert(t, cap)
    end
    last_end = e + 1
    s, e, cap = str:find(fpat, last_end)
  end
  if last_end <= #str then
    cap = str:sub(last_end)
    table.insert(t, cap)
  end
  return t
end

M.openFileInADO = function(branch)
  local currentBranch = branch or M.trim(vim.fn.system({ "git", "rev-parse", "--abbrev-ref", "HEAD" }))
  local fileName = "/" .. vim.fn.expand("%:~:.")
  local remoteOrigin = M.trim(vim.fn.system({ "git", "config", "--get", "remote.origin.url" }))
  local remoteUrl = M.split(remoteOrigin, "@")[2]

  vim.print(remoteUrl)
  local cmd = string.format(
    [[open -a "/Applications/Google Chrome.app" 'https://%s?path=%s&version=GB%s&_a=contents']],
    remoteUrl,
    fileName,
    currentBranch
  )
  os.execute(cmd)
end

return M
