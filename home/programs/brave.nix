{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  name = "brave";
  cfg = config.browser.${name};
in {
  options.browser.${name}.enable = mkEnableOption "Enable ${name}";

  config = mkIf cfg.enable {
    programs.${name} = {
    enable = true;
    extensions = let
      id = {
        dark-reader = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
        privacy-badger = "pkehgijcmpdhfbdbbnkijodmdjhbjlgp";
        vimuim = "dbepggeogbaibhgnhhndojpepiihcmeb";
        duckduckgo-privacy-essentials = "bkdgflcldnnnapblkhphbgpggdiikppg";
        bitwarden = "nngceckbapebfimnlniiiahkandclblb";
        material-icons-for-github = "bggfcpfjbdkhfhfmkjpbhnkhnpjjeomc";
        cnl-decryptor = "hfmolcaikbnbminafcmeiejglbeelilh"; # JDownloader "CNL Decryptor"
      };
    in
      builtins.attrValues (builtins.mapAttrs (n: v: {id = v;}) id);
  };
};
}
