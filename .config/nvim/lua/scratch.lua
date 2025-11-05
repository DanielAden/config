local utils = require("utils")
-- local Job = require("plenary.job");

-- local group = vim.api.nvim_create_augroup("TestAutoGroup", { clear = true })
--
-- vim.api.nvim_create_autocmd("BufEnter", { command = "echo 'Hello'", group = group });
--

-- vim.api.nvim_create_user_command("GitFollow", function()
--   Job:new({
--     command = 'echo',
--     args = { '$SPECFLOW_ENVIRONMENT' },
--     cwd = '/usr/bin',
--     -- env = { ['a'] = 'b' },
--     on_exit = function(j, return_val)
--       print(vim.tbl_values(return_val))
--       -- vim.tbl_values(j:result())
--     end,
--   }):sync() -- or start()
-- end, { nargs = 0 })
--

-- Replaces {{ field }} with the value. ex: "{{tenantSchema}}" -> "T99999999"
