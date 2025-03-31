let
  inherit (import ./variables.nix) timezone locale;
in {
  time.timeZone = "${timezone}";
  i18n.defaultLocale = "${locale}";
}
