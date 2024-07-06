#ios.nix
{ config, pkgs, lib, ... }: 

{
services.usbmuxd.enable = true;

# optional in case of mounting issues
#services.usbmuxd = {
#  enable = true;
#  package = pkgs.usbmuxd2;
#};

environment.systemPackages = with pkgs; [
  libimobiledevice
  ifuse # optional, to mount using 'ifuse'
];

}

# https://nixos.wiki/wiki/IOS
#Mounting the device via iFuse is possible with the following commands
#$ mkdir /tmp/iphone
#$ ifuse /tmp/iphone
#
#Tethering
#Tethering on iOS is possible via Wifi hotspot, Bluetooth or USB. In order to enable USB tethering, first enable tethering in the iOS #networking settings. After that run following command
#$ idevicepair pair
#Confirm pairing by accepting the connection on your iOS device. After that an ethernet device will appear in your network device list. 
