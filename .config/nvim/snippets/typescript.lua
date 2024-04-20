
local ls = require "luasnip"
local i = ls.insert_node
local s = ls.s
local t = ls.text_node

return {
	s("afn", {
		t("const "), i(1, "fnName"), t(" = ("), i(2, "params"), t("): "), i(3, "Type"), t({" => {", "  " }),
		i(4, "body"),
		t({ "", "};" })
	}),

	s("afnempty", {
		t("const "), i(1, "fnName"), t(" = (): "), i(2, "Type"), t({" => {", "  " }),
		i(3, "body"),
		t({ "", "};" })
	}),

	s("ternary", {
		-- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
		i(1, "cond"), t(" ? "), i(2, "then"), t(" : "), i(3, "else")
	}),

	s("cdir", {
		t("console.dir({ "), i(1, "key"), t(" })")
	}),

	s("clog", {
		t("console.log("), i(1, "key"), t(")")
	}),

	s("deconstruct", {
		t("const { "), i(2, "fields"), t(" } = "), i(1, "var"), t(";"),
	}),
}


