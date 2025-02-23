local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local filePath = "/Users/dat3631/Notes/tenants.md"
local seperator = "================================================================================="

function split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

function convertTenantFile(lines)
	local data = {}
	local item = {}

	for _, line in ipairs(lines) do
		line = line:match("^()%s*$") and "" or line:match("^%s*(.*%S)")
		if line == seperator then
			if next(item) ~= nil then
				data[item["name"]] = item
			end
			item = {}
		else
			if string.find(line, "https://") then
				item["url"] = line
			elseif line:sub(1, 1) == "T" then
				item["schema"] = line
			elseif string.find(line, "_") then
				item["customerrecords"] = line .. ".customerrecords"
				item["customer_creditbureau"] = line .. ".customer_creditbureau"
			else
				item["id"] = line
				item["name"] = lines[_ - 3]
			end
		end
	end

	if next(item) ~= nil then
		data[item["name"]] = item
	end

	return data
end

function getFileContent(filePath)
	local file = io.open(filePath, "r")
	if file then
		-- Read the whole file
		local content = file:read("*all")
		return content
	else
		print("File not found")
	end
end

function getKeys(table)
	local keyset = {}
	local n = 0

	for k, v in pairs(table) do
		n = n + 1
		keyset[n] = k
	end

	return keyset
end

local tenantData
if not tenantData then
	tenantData = convertTenantFile(split(getFileContent(filePath), "\n"))
end

-- our picker function: colors
local colors = function(opts)
	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = "colors",
			finder = finders.new_table({
				results = { "red", "green", "blue" },
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					-- print(vim.inspect(selection))
					vim.api.nvim_put({ selection[1] }, "", false, true)
				end)
				return true
			end,
		})
		:find()
end

-- to execute the function
-- colors()
-- colors(require("telescope.themes").get_dropdown({}))

-- our picker function: colors
local tenantPicker = function(opts)
	opts = opts or {}
	pickers
		.new(opts, {
			prompt_title = "Tenants",
			finder = finders.new_table({
				results = getKeys(tenantData),
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					local schema = tenantData[selection[1]]["schema"]
					vim.api.nvim_put({ schema }, "", false, true)
				end)
				return true
			end,
		})
		:find()
end

vim.keymap.set("n", "<leader>sy", tenantPicker)

-- to execute the function
-- colors()
-- colors(require("telescope.themes").get_dropdown({}))
--
--
