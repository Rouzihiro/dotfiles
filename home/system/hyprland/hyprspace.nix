{
  pkgs,
  inputs,
  ...
}: {
  wayland.windowManager.hyprland = {
    plugins = [
      inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
    ];
    extraConfig = ''
      bind = Alt, Tab, overview:toggle
      bind = Alt+Shift, Tab, overview:toggle, all

      plugin {
        overview {
          onBottom = true
          workspaceMargin = 11
          workspaceBorderSize = 2
          centerAligned = true
          panelHeight = 320
          drawActiveWorkspace = true
          switchOnDrop = true
          affectStrut = false

          workspaceActiveBorder = rgba(cba6f7ff)
          workspaceInactiveBorder = rgba(b4befecc)
          disableBlur = false
        }
      }
    '';
  };
}
