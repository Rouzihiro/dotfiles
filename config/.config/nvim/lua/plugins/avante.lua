require("avante").setup({
    provider = "ollama",

    providers = {
        ollama = {
            endpoint = "http://127.0.0.1:11434",
            model = "qwen2.5:3b",

            timeout = 30000,

            extra_request_body = {
                think = false,

                options = {
                    temperature = 0.2,
                    num_ctx = 2048,
                    top_p = 0.9,
                },
            },
        },
    },

    behaviour = {
        auto_set_keymaps = false,
        auto_apply_diff_after_generation = false,
        auto_focus_sidebar = true,
    },

    windows = {
        position = "right",
        wrap = true,
        width = 35,
        sidebar_header = {
            align = "center",
            rounded = true,
        },
    },

    hints = {
        enabled = true,
    },

    diff = {
        autojump = true,
        list_opener = "copen",
    },
})
