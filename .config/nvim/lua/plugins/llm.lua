return {
	"huggingface/llm.nvim",
	enabled = false,
	opts = {
		backend = "ollama",
		-- model = "qwen2.5-coder:7b",
		model = "starcoder2:7b",
		url = "http://127.0.0.1:11435",
		tokens_to_clear = { "<|endoftext|>" },
		fim = {
			enabled = true,
			prefix = "<fim_prefix>",
			middle = "<fim_middle>",
			suffix = "<fim_suffix>",
		},
		request_body = {
			options = {
				temperature = 0.2,
				top_p = 0.95,
			},
		},
		context_window = 4096,
		debounce_ms = 150,
		-- accept_keymap = "<Tab>",
		-- dismiss_keymap = "<S-Tab>",
		enable_suggestions_on_startup = true,
		enable_suggestions_on_files = "*",
		tokenizer = nil,
	},
}
