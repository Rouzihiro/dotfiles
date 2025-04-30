# NixOS-config
My personal NixOS configuration for Acer VX 15 Laptop 
OS: NixOS 23.11.7122.9ddcaffecdf0 (Tapir) x86_64 
Host: KBL Wish_KLS 
Kernel: 6.1.90 
Packages: 2076 (nix-system), 373 (nix-user) 
Shell: bash 5.2.15 
Resolution: 1920x1080 
DE: GNOME 45.5 (Wayland) 
WM: Mutter 
Terminal: kgx 
CPU: Intel i7-7700HQ (8) @ 3.800GHz 
dGPU: NVIDIA GeForce GTX 1050 Ti Mobile 
iGPU: Intel HD Graphics 630 
Memory:16 GB 


Finally got everything working with my latest configuration:
- Steam
- Heroic Game Launcher
- Lutris
- Cemu - runs with this "trick" after I found out that wayland was the main problem: GDK_BACKEND=x11 cemu

