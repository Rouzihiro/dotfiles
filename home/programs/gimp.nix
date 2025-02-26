{pkgs, ...}: {
  home.packages = [pkgs.gimp];
  xdg.configFile."GIMP/2.10/themerc".text = ''
    style "gimp-spin-scale-style"
    {
      GimpSpinScale::compact = 1
    }

    class "GimpSpinScale" style "gimp-spin-scale-style"

    include "/nix/store/czr51zdw8qkz17a7c1snkiyj00w416ha-gimp-2.10.38/share/gimp/2.0/themes/System/gtkrc"
    include "/nix/store/czr51zdw8qkz17a7c1snkiyj00w416ha-gimp-2.10.38/etc/gimp/2.0/gtkrc"
  '';
}
