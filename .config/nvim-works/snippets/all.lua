---@diagnostic disable: undefined-global

return {
    -- Global / all filetypes
    s("date", t(os.date("%Y/%m/%d"))),
    s("time", t(os.date("%H:%M:%S"))),

    -- Emails / handles / links
    s("mail", t("ryossj@gmail.com")),
    s("email", t("ryossj@gmail.com")),
    s("uvm", t("@uvm.edu")),
    s("gh", t("github.com/Rouzihiro")),
		s("regards", t("Kind regards, [Rey Z.](https://github.com/Rouzihiro/dotfiles)")),
		s("ciao", t("Kind regards, [Rey Z.](https://github.com/Rouzihiro/dotfiles)")),

    -- Brackets / delimiters with placeholders
    s("(", { t("("), i(1), t(")") }),
    s("[", { t("["), i(1), t("]") }),
    s("{", { t("{"), i(1), t("}") }),
    s("$", { t("$"), i(1), t("$") }),

    -- Scripts / shell headers
    s("script", { t({"#!/bin/bash", "source fzf_selector.sh"}), i(1) }),
    s("bash",   { t({"#!/usr/bin/env bash"}), i(1) }),
    s("sh",     { t({"#!/usr/bin/env sh"}), i(1) }),

    -- Markdown snippets
    s("link", { t("["), i(1), t("]("), i(2), t(")") }),
    s("img",  { t("!["), i(1, "alt text"), t("]("), i(2, "path/to/image.png"), t(")") }),

    -- Typst snippet
    s("par", { t({"#par(first-line-indent: 3em)[", "    "}), i(1), t({"", "]"}) }),
}
