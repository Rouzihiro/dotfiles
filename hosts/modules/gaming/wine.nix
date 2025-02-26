{ pkgs, ... }:
{
  
  environment.systemPackages = with pkgs; [
  wine
];

}
