local Job = require("plenary.job")
local M = {}

M.trim = function(s)
	return string.gsub(s, "[\r\n ]", "")
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

M.findInTable = function(tbl, predicate)
	for i, value in ipairs(tbl) do
		if predicate(value, i) then
			return value
		end
	end
	return nil -- Return nil if no match is found
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

M.map = function(tbl, f)
	local t = {}
	for k, v in pairs(tbl) do
		t[k] = f(v)
	end
	return t
end

M.getRandomNumers = function(s, e)
	math.randomseed(os.time())
	local randomNumber = math.random(s, e)
	return randomNumber
end

M.slice = function(tbl, startIdx, endIdx)
	endIdx = endIdx or #tbl
	local sliced = {}
	for i = startIdx, endIdx do
		table.insert(sliced, tbl[i])
	end
	return sliced
end

M.readFile = function(filePath)
	local file = io.open(filePath, "r")
	if not file then
		return nil
	end

	local content = file:read("*a")
	file:close()
	return content
end

M.getSettings = function()
	local settingsPath = os.getenv("HOME") .. "/global_settings.json"
	local file = M.readFile(settingsPath)
	if not file then
		print("Settings file not found: " .. settingsPath)
		return nil
	end

	local settings = vim.json.decode(file)
	return settings
end

M.getGlobalSettings = function(env, tenant)
	local settings = M.getSettings()
	if not settings then
		return nil
	end

	settings = settings["tenantConfig"]

	if not settings[env] then
		print("Environment not found in settings: " .. env)
		return nil
	end

	local tenants = settings[env]["tenants"]
	if not tenants then
		print("tenant list not in settings")
		return nil
	end

	local tenantConfig = M.findInTable(tenants, function(t)
		print(t["name"])
		return string.lower(t["name"]) == string.lower(tenant)
	end)

	if not tenant then
		print("Tenant not found in settings: " .. tenant)
		return nil
	end

	return tenantConfig
end

M.getGlobalSbSettings = function(env)
	local settings = M.getSettings()
	if not settings then
		return nil
	end

	local sbSettings = settings["serviceBusConfig"]
	if not sbSettings[env] then
		print("Service Bus settings not found for environment: " .. env)
		return nil
	end

	local envSettings = sbSettings[env]
	if not envSettings then
		print("Service Bus settings not found for environment: " .. env)
		return nil
	end

	return settings["serviceBusConfig"]
end

M.exec = function(cmd)
	local handle = io.popen(cmd)
	local result = handle:read("*a")
	handle:close()
	return result
end

M.sendCurlRequest = function(_args)
	local args = {}
	local i = 1
	for _, arg in pairs(_args) do
		for k, v in pairs(arg) do
			local line = ""
			if k == "url" then
				line = "--" .. k .. " " .. v
			else
				line = "--" .. k .. " " .. "'" .. v .. "'"
			end
			args[#args + 1] = line
		end
		i = i + 1
	end

	-- local cmd = "curl " .. table.concat(args, " \\ \n")
	local cmd = "curl " .. table.concat(args, " ")
	-- print(cmd)
	os.execute(cmd)

	-- Job:new({
	-- 	command = "curl",
	-- 	args = args,
	-- 	on_exit = function(j, return_val)
	-- 		print("result")
	-- 		local result = j:result()
	-- 		print(vim.inspect(result))
	-- 	end,
	-- }):sync() -- or start()
end

return M
