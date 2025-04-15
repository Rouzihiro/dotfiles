# Direnv
eval "$(${pkgs.direnv}/bin/direnv hook bash)"

# Zoxide
eval "$(${pkgs.zoxide}/bin/zoxide init bash)"

# FZF
source ${pkgs.fzf}/share/fzf/key-bindings.bash

