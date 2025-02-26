{ stdenv, fetchFromGitHub, lib }:

stdenv.mkDerivation rec {
  pname = "infinity-glass-icons";
  version = "1.0"; 

  src = fetchFromGitHub {
    owner = "Rouzihiro"; 
    repo = "infinity-glass-icons";
    rev = "main"; 
    sha256 = "sha256-svPqV+L4u7cXDJ72XrKIz0AOHJzxFQmELYsSIoiOVeA";  
  };

  dontCheckForBrokenSymlinks = true;

  installPhase = ''
    mkdir -p $out/share/icons/Infinity
    cp -r $src/Infinity/* $out/share/icons/Infinity
  '';

  meta = with lib; {
    description = "Infinity-Glass icon theme";
    homepage = "https://github.com/Rouzihiro/infinity-glass-icons";
    platforms = platforms.all;
  };
}

