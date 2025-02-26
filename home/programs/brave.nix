{
programs.brave = {
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
}
