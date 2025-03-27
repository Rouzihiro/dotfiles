# snippets.nix
{ lib }:
let
  # Helper function to create snippets with proper escaping
  mkSnippet = trigger: description: body: {
    inherit trigger description;
    body = lib.concatStringsSep "\n" (map (line: builtins.replaceStrings ["$"] ["''$"] line) body);
  };

   # Helper to create placeholders that survive Nix evaluation
  ph = num: text: "''$${${toString num}:${text}}";
in
{
  nix = {
    # Package arguments
    pkgs-arg = mkSnippet "pkgs" "Standard Nixpkgs argument" [
      "{ pkgs ? import <nixpkgs> {} }:"
    ];

    flake-pkgs = mkSnippet "fpkgs" "Flake-compatible pkgs" [
      "{ pkgs ? import inputs.nixpkgs { inherit system; },"
      "  system ? \"x86_64-linux\","
      "  ..."
      "}:"
    ];

    # Shell scripts
    writeShellScript = mkSnippet "wsh" "writeShellScriptBin" [
      "pkgs.writeShellScriptBin \"${ph 1 "name"}\" ''"
      "  #!/bin/sh"
      "  ${ph 2 "# Script content"}"
      "''"
    ];

    # Development environments
    mkShell = mkSnippet "mksh" "Create dev shell" [
      "pkgs.mkShell {"
      "  name = \"${ph 1 "env-name"}\";"
      "  buildInputs = with pkgs; [ ${ph 2 "packages"} ];"
      "};"
    ];

    # Home Manager
    home-packages = mkSnippet "hpkgs" "Home manager packages" [
      "home.packages = with pkgs; ["
      "  ${ph 1 "packages"}"
      "];"
    ];

    # Variable inheritance
    inherit-vars = mkSnippet "inh" "Inherit variables" [
      "{ pkgs, ... }: let"
      "  inherit (import ../../hosts/modules/variables.nix) ${ph 1 "variables"};"
      "in {"
    ];

    # Derivation patterns
    mkDerivation = mkSnippet "mkd" "stdenv.mkDerivation" [
      "stdenv.mkDerivation {"
      "  pname = \"${ph 1 "name"}\";"
      "  version = \"${ph 2 "version"}\";"
      "  src = ${ph 3 "source"};"
      "  meta = with lib; {"
      "    description = \"${ph 4 "description"}\";"
      "    license = licenses.${ph 5 "mit"};"
      "  };"
      "};"
    ];

    # Utility snippets
    empty-hash = mkSnippet "hash" "Empty SRI hash" [
      "hash = \"sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=\";"
    ];

    # Flake templates
    flake-output = mkSnippet "flk" "Basic flake output" [
      "{"
      "  inputs = {"
      "    nixpkgs.url = \"github:NixOS/nixpkgs/nixos-unstable\";"
      "  };"
      ""
      "  outputs = { self, nixpkgs, ... }: {"
      "    nixosConfigurations = {"
      "      ${ph 1 "hostname"} = nixpkgs.lib.nixosSystem {"
      "        system = \"x86_64-linux\";"
      "        modules = [ ${ph 2 "./configuration.nix"} ];"
      "      };"
      "    };"
      "  };"
      "}"
    ];
  };
}
