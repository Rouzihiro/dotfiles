{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "nas-mounting-shell";
  
  buildInputs = with pkgs; [
    # Core mounting utilities
    util-linux       # for mount/umount commands
    nfs-utils        # for NFS mounts
    cifs-utils       # for SMB/CIFS mounts
    
    # Network diagnostics
    inetutils        # basic networking tools
    iproute2         # advanced networking tools
    dnsutils         # DNS tools (nslookup, dig)
    
    # Filesystem tools
    ntfs3g           # NTFS support
    exfat            # exFAT support
    hfsprogs         # HFS+ support (for Mac)
    
    # Authentication tools
    samba            # for SMB authentication
    krb5             # Kerberos authentication
    openldap         # LDAP tools if needed
    
    # Monitoring tools
    smartmontools    # disk health monitoring
    hdparm           # disk performance tools
    
    # Optional but useful
    autofs5          # for automatic mounting
    sshfs            # for mounting over SSH
    curl             # for testing web endpoints
    wget             # alternative to curl
  ];
  
  shellHook = ''
    echo "NAS Mounting Tools Shell"
    echo "Available commands:"
    echo "  mount, umount, mount.nfs, mount.cifs"
    echo "  smbclient, nslookup, dig, ping"
    echo "  smartctl, hdparm, sshfs"
  '';
}
