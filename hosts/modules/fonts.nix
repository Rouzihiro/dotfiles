# dont forget to run: fc-cache -fv

{ pkgs, ... }: {
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      iosevka
      nerd-fonts.jetbrains-mono
      monaspace
      cascadia-code
      dejavu_fonts

      (pkgs.runCommand "FoundationOne" {
        buildInputs = [ pkgs.coreutils ]; 
      } ''
        mkdir -p $out/share/fonts/truetype
        ln -s ${builtins.toString /home/rey/dotfiles/fonts/FoundationOne.ttf} $out/share/fonts/truetype/FoundationOne.ttf
      '')

      # Add new custom fonts
      (pkgs.runCommand "Astonic" {
        buildInputs = [ pkgs.coreutils ];
      } ''
        mkdir -p $out/share/fonts/opentype
        ln -s ${builtins.toString /home/rey/dotfiles/fonts/Astonic.otf} $out/share/fonts/opentype/Astonic.otf
      '')

      (pkgs.runCommand "DigitalCards" {
        buildInputs = [ pkgs.coreutils ];
      } ''
        mkdir -p $out/share/fonts/truetype
        ln -s ${builtins.toString /home/rey/dotfiles/fonts/DigitalCards.otf} $out/share/fonts/truetype/DigitalCards.otf
        ln -s ${builtins.toString /home/rey/dotfiles/fonts/DigitalCards.ttf} $out/share/fonts/truetype/DigitalCards.ttf
      '')

      (pkgs.runCommand "Dracutaz" {
        buildInputs = [ pkgs.coreutils ];
      } ''
        mkdir -p $out/share/fonts/opentype
        ln -s ${builtins.toString /home/rey/dotfiles/fonts/Dracutaz.otf} $out/share/fonts/opentype/Dracutaz.otf
        ln -s ${builtins.toString /home/rey/dotfiles/fonts/Dracutaz.ttf} $out/share/fonts/opentype/Dracutaz.ttf
      '')

      (pkgs.runCommand "Ekors" {
        buildInputs = [ pkgs.coreutils ];
      } ''
        mkdir -p $out/share/fonts/opentype
        ln -s ${builtins.toString /home/rey/dotfiles/fonts/Ekors.otf} $out/share/fonts/opentype/Ekors.otf
      '')

      (pkgs.runCommand "Glamrb" {
        buildInputs = [ pkgs.coreutils ];
      } ''
        mkdir -p $out/share/fonts/truetype
        ln -s ${builtins.toString /home/rey/dotfiles/fonts/Glamrb.ttf} $out/share/fonts/truetype/Glamrb.ttf
      '')

      (pkgs.runCommand "Hemicube" {
        buildInputs = [ pkgs.coreutils ];
      } ''
        mkdir -p $out/share/fonts/truetype
        ln -s ${builtins.toString /home/rey/dotfiles/fonts/Hemicube.ttf} $out/share/fonts/truetype/Hemicube.ttf
        ln -s ${builtins.toString /home/rey/dotfiles/fonts/HemicubelLogo.ttf} $out/share/fonts/truetype/HemicubelLogo.ttf
        ln -s ${builtins.toString /home/rey/dotfiles/fonts/HemicubeType.ttf} $out/share/fonts/truetype/HemicubeType.ttf
      '')

      (pkgs.runCommand "Jodaguz" {
        buildInputs = [ pkgs.coreutils ];
      } ''
        mkdir -p $out/share/fonts/opentype
        ln -s ${builtins.toString /home/rey/dotfiles/fonts/Jodaguz.otf} $out/share/fonts/opentype/Jodaguz.otf
        ln -s ${builtins.toString /home/rey/dotfiles/fonts/Jodaguz.ttf} $out/share/fonts/opentype/Jodaguz.ttf
      '')

      (pkgs.runCommand "Kryptonian" {
        buildInputs = [ pkgs.coreutils ];
      } ''
        mkdir -p $out/share/fonts/truetype
        ln -s ${builtins.toString /home/rey/dotfiles/fonts/Kryptonian.ttf} $out/share/fonts/truetype/Kryptonian.ttf
      '')

      (pkgs.runCommand "Nero" {
        buildInputs = [ pkgs.coreutils ];
      } ''
        mkdir -p $out/share/fonts/opentype
        ln -s ${builtins.toString /home/rey/dotfiles/fonts/Nero.otf} $out/share/fonts/opentype/Nero.otf
      '')

      (pkgs.runCommand "Powerworld" {
        buildInputs = [ pkgs.coreutils ];
      } ''
        mkdir -p $out/share/fonts/truetype
        ln -s ${builtins.toString /home/rey/dotfiles/fonts/Powerworld.ttf} $out/share/fonts/truetype/Powerworld.ttf
      '')

      (pkgs.runCommand "RocketScript" {
        buildInputs = [ pkgs.coreutils ];
      } ''
        mkdir -p $out/share/fonts/truetype
        ln -s ${builtins.toString /home/rey/dotfiles/fonts/RocketScript.ttf} $out/share/fonts/truetype/RocketScript.ttf
      '')

      (pkgs.runCommand "SomewhereInSpace" {
        buildInputs = [ pkgs.coreutils ];
      } ''
        mkdir -p $out/share/fonts/truetype
        ln -s ${builtins.toString /home/rey/dotfiles/fonts/SomewhereInSpace.ttf} $out/share/fonts/truetype/SomewhereInSpace.ttf
      '')

      (pkgs.runCommand "SpaceMission" {
        buildInputs = [ pkgs.coreutils ];
      } ''
        mkdir -p $out/share/fonts/opentype
        ln -s ${builtins.toString /home/rey/dotfiles/fonts/SpaceMission.otf} $out/share/fonts/opentype/SpaceMission.otf
        ln -s ${builtins.toString /home/rey/dotfiles/fonts/SpaceMission.ttf} $out/share/fonts/opentype/SpaceMission.ttf
      '')

      (pkgs.runCommand "Squalor" {
        buildInputs = [ pkgs.coreutils ];
      } ''
        mkdir -p $out/share/fonts/truetype
        ln -s ${builtins.toString /home/rey/dotfiles/fonts/Squalor.ttf} $out/share/fonts/truetype/Squalor.ttf
      '')
    ];
  };
}

