{ ... }:

{
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024; # Size in megabytes (16 GB)
    }
  ];

}
