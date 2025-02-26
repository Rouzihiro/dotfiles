{ pkgs, ... }:
{
 environment.systemPackages = with pkgs; [
   lxqt.lxqt-policykit
  ];


}
