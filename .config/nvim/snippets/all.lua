

local ls = require "luasnip"
local i = ls.insert_node
local s = ls.s
local t = ls.text_node


return {

	-- s("arrowfn", {
	-- 	-- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
	-- 	-- i(1, "cond"), t(" ? "), i(2, "then"), t(" : "), i(3, "else")
	-- 	t("const "), i(1, "fnName"), t(" = ("), i(2, "params"), t("): "), i(3, "Type"), t(" => { "), i(4, "body"), t(" }")
	-- })
}


