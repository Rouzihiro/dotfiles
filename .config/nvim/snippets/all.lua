
---@diagnostic disable: undefined-global

return {
    s("date", t(os.date("%Y/%m/%d"))),
    s("time", t(os.date("%H:%M:%S"))),
    s("mail", t("ryossj@gmail.com")),
    s("email", t("ryossj@gmail.com")),
    s("uvm", t("@uvm.edu")),
    s("gh", t("github.com/Rouzihiro")),
    s("(", { t("("), i(1), t(")") }),
    s("[", { t("["), i(1), t("]") }),
    s("{", { t("{"), i(1), t("}") }),
    s("$", { t("$"), i(1), t("$") }),
    s("script", t({ "#!/bin/bash", "source fzf_selector.sh" }), i(1)),
}
