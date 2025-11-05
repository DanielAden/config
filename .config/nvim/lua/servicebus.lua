-- Quick script to send Azure service bus events from within Neovim
--
-- Requires 'sbtoken' cli script to get the auth token
-- Requires SERVICEBUS_CONFIG_LOCATION env variable to point to config json file containing
-- information about environment, tenant, topic, and service bus uri
--
local utils = require("utils")

local configStoreLocation = vim.g.servicebus_config_location

function ReplaceServiceBusBodyParams(body, tenant)
	local replacedBody = body
	local replacements = {
		jwt = tenant["jwt"],
		contractNumber = tenant["contractNumber"],
		tenantSchema = "T" .. tenant["contractNumber"],
		tenantId = tenant["tenantId"],
	}
	for key, value in pairs(replacements) do
		local placeholder = "{{" .. key .. "}}"
		replacedBody = string.gsub(replacedBody, placeholder, value)
	end
	return replacedBody
end

-- curl --request POST \
--   --url https://sb-cmfg-d02-dlx.servicebus.windows.net/memberrecon-topic/messages \
--   --header 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkhTMjNiN0RvN1RjYVUxUm9MSHdwSXEyNFZZZyIsImtpZCI6IkhTMjNiN0RvN1RjYVUxUm9MSHdwSXEyNFZZZyJ9.eyJhdWQiOiJodHRwczovL3NiLWNtZmctZDAyLWRseC5zZXJ2aWNlYnVzLndpbmRvd3MubmV0IiwiaXNzIjoiaHR0cHM6Ly9zdHMud2luZG93cy5uZXQvYTAwNDUyZmQtODQ2OS00MDllLTkxYTgtYmI3YTAwOGUyZGEwLyIsImlhdCI6MTc1OTQ0MTQ4MiwibmJmIjoxNzU5NDQxNDgyLCJleHAiOjE3NTk0NDY5OTYsImFjciI6IjEiLCJhaW8iOiJBWFFBaS84YUFBQUFvNmVWQXlrVEJKdTNRa2FQRnZlYzFvdy9OMkkwNTlGczEwQTU0M2ZHVHBvcXB0bEVLc25EN0tnejRBYW5ZN0ZISDFWdVFmSE8yTHNIZmJZd1RpZkJMVWZlWUUyZXFWYU1NYSttYlYyL0ZtbFRHT1laakc5U2Q5Rmg2YjAzc1JkSmRuRFkyenJxemJ6Vm4wTEVxeHpTdVE9PSIsImFtciI6WyJtZmEiXSwiYXBwaWQiOiIwNGIwNzc5NS04ZGRiLTQ2MWEtYmJlZS0wMmY5ZTFiZjdiNDYiLCJhcHBpZGFjciI6IjAiLCJmYW1pbHlfbmFtZSI6IkFkZW4iLCJnaXZlbl9uYW1lIjoiRGFuaWVsIiwiZ3JvdXBzIjpbIjQ1NGYzYTdhLTQyNWEtNDRjZS05NjljLWIyZGY5OWE4OWYxMSIsIjg3NTg4MDAxLTYxNzctNDNlOC05MGI2LWY4ZTVkMzA2Yzk0YyIsImVjNTMxMTg1LWIzZDctNGY5Yy1iMGE1LWRmOTZiZTlmZGM2NiIsIjkyODcxZTk3LTM1ZmUtNDM4Ny1iN2EzLWI1OTg1MDU3Y2FlNSIsIjZiYjRkNTUxLTZhNjQtNDE0ZS1hYzBmLWU2ZTY1NWFmZGUxNSIsIjBjOTJmNGQzLWZkZDgtNGE1YS05YWJlLThlY2NmZjVhZWJiNiIsIjJhZWE1MzZjLWZmNGMtNDYzMS1hYjIzLTNlOWNmYjcwZmZkNyIsIjc2Yjg0OWI0LWU5MTctNDVmYi05MTBlLTYwNjNmYjMxYzNlOSIsIjg4NDRlYjYwLTliMTItNGE5OS05OTg4LTFlNDAzMjJkZmE2NyJdLCJpZHR5cCI6InVzZXIiLCJpcGFkZHIiOiIxNjMuMTE2LjEzMy4xMTkiLCJuYW1lIjoiQWRlbiwgRGFuaWVsIiwib2lkIjoiYmMzZWZhYTctY2Y0Ni00NzFiLWEyNDAtY2VmNDA5YWZmNmEyIiwib25wcmVtX3NpZCI6IlMtMS01LTIxLTIyMDUyMzM4OC0yNjE5MDM3OTMtNjgyMDAzMzMwLTI3NDQ5NiIsInB1aWQiOiIxMDAzMjAwMENFMTMzMTJBIiwicmgiOiIxLkFWc0FfVklFb0dtRW5rQ1JxTHQ2QUk0dG9OYWVOb0FSWDlsTnZ2TnBKSFdFWG5kYkFEQmJBQS4iLCJzY3AiOiJ1c2VyX2ltcGVyc29uYXRpb24iLCJzaWQiOiIwMDRlOWQxOS1lYWVjLWI1YTMtNjRiZC0yN2Y2Mjg5OWUwOTUiLCJzdWIiOiJGVlZ5NmpBTWtlOTQwWEdNMVFlZXZocHBLWUVLNGZ0TjJna2JQNW0yUGV3IiwidGlkIjoiYTAwNDUyZmQtODQ2OS00MDllLTkxYTgtYmI3YTAwOGUyZGEwIiwidW5pcXVlX25hbWUiOiJkYXQzNjMxLUxTQUBDTVVUVUFMLkNPTSIsInVwbiI6ImRhdDM2MzEtTFNBQENNVVRVQUwuQ09NIiwidXRpIjoiTExmeGVEenNtRS0xQ0l5alZITjBBQSIsInZlciI6IjEuMCIsIndpZHMiOlsiYjc5ZmJmNGQtM2VmOS00Njg5LTgxNDMtNzZiMTk0ZTg1NTA5Il0sInhtc19mdGQiOiJxVk5uMGRPMEJLbzJ5QXBmd1A5eTRkYjhSbFNxUFgzSG5MaV9iMzd0b1J3QmRYTnViM0owYUMxa2MyMXoiLCJ4bXNfaWRyZWwiOiIxIDMwIn0.ab4phskhruB2yMaW3LYiUQp0BVv4S4_nQpRostRSucOZq1H-ybX4xxpM7e_TteHPcA23fM56ZW_9c11xgbf_OQ07LpYDZRtLzKhrDweSm2Do24DABOrA05iA_o4HSxysw87_Tx7tfKHrz7HCxcVYANN2a-DropSHiromHIv8gdRrMfZZVQgG5VJfG2CH5wkEsRviQQHIq_PJ4sAFs0Xi_WiNK3EGdx3wgab_bd4b5Xm0sEjDe82HVy8KbCQ94BoiSD13p9SayrCOVn3AgcsSNv2KaQgoh80tfqxH-rgmcjXlzUiYtZHgvveNooRcUqcP5kQcuwOmVFX4rgKHLz-Iqg' \
--   --header 'Content-Type: application/json' \
--   --header 'DLX-EVENT-TYPE: Loan.ReconciliationRequired' \
--   --data '{}'
function SendSBEvent()
	if configStoreLocation == nil or configStoreLocation == "" then
		print("Environment variable 'SERVICEBUS_CONFIG_LOCATION' not set, exiting...")
		return
	end

	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local event = utils.trim(string.gsub(lines[1], "//", ""))
	-- print("Sending SB Event: " .. event)
	local body = table.concat(utils.slice(lines, 2), "\n")

	local configJson = utils.readFile(configStoreLocation)
	if not configJson then
		print("Config file " .. configStoreLocation .. "not found")
		return
	end

	local sbSenderConfig = vim.json.decode(configJson)
	local env = sbSenderConfig["env"]
	local tenant = sbSenderConfig["tenantSetting"]
	local topic = sbSenderConfig["topic"]["name"]
	local serviceBusUri = sbSenderConfig["serviceBusUri"]

	if not env or not tenant or not topic then
		print("Environment or tenant or topic not found in config!")
		return
	end

	body = ReplaceServiceBusBodyParams(body, tenant)
	local tokenResult = utils.exec("sbtoken " .. env)

	local token = utils.trim(utils.split(tokenResult, "\n")[2])

	utils.sendCurlRequest({
		{ request = "POST" },
		{ url = serviceBusUri },
		{ header = string.format("Authorization: Bearer %s", token) },
		{ header = "Content-Type: application/json" },
		{ header = string.format("DLX-EVENT-TYPE: %s", event) },
		{ data = body },
	})
end

if vim.g.which_comp == "WORK" then
	vim.api.nvim_create_user_command("SendSBEvent", SendSBEvent, { nargs = 0 })
	vim.keymap.set("n", "<leader><leader>e", ":SendSBEvent<CR>", { desc = "Send Service Bus Event" })
end
