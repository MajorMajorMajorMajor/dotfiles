{
  description = "NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    llm-agents-pinned = {
      url = "github:MajorMajorMajorMajor/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    dank-material-shell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    noctalia-shell = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    dedrm = {
      url = "github:noDRM/DeDRM_tools/v10.0.9";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    nixos-hardware,
    nixos-wsl,
    llm-agents,
    llm-agents-pinned,
    dank-material-shell,
    noctalia-shell,
    ...
  } @ inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [ "libsoup-2.74.3" ];
      };
    };
    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "libsoup-2.74.3"
          "electron-39.8.10"
        ];
      };
    };
    specialArgs = { inherit inputs llm-agents llm-agents-pinned pkgs-unstable; };
    featherCommon = [
      # rebuild target
      { environment.etc."nixos-rebuild-target".text = "feather\n"; }

      # hardware and host-specific config
      ./hosts/feather

      # shared system modules
      ./modules/common.nix
      ./modules/desktop.nix
      ./modules/gnome-circle.nix
      ./modules/ai.nix
      nixos-hardware.nixosModules.microsoft-surface-pro-intel
    ];
  in {
    nixosConfigurations.feather = nixpkgs.lib.nixosSystem {
      inherit system pkgs specialArgs;
      modules = featherCommon ++ [
        # default DE — change this one line to swap the default
        ./hosts/feather/gnome.nix

        # specialisations: self-contained, no cross-DE knowledge
        {
          specialisation.gnome = {
            inheritParentConfig = false;
            configuration = {
              imports = featherCommon ++ [ ./hosts/feather/gnome.nix ];
              environment.etc."nixos-current-specialisation".text = "gnome";
            };
          };
          specialisation.niri = {
            inheritParentConfig = false;
            configuration = {
              imports = featherCommon ++ [ ./hosts/feather/niri.nix ];
              environment.etc."nixos-current-specialisation".text = "niri";
            };
          };
          specialisation.niri-noctalia = {
            inheritParentConfig = false;
            configuration = {
              imports = featherCommon ++ [ ./hosts/feather/niri-noctalia.nix ];
              environment.etc."nixos-current-specialisation".text = "niri-noctalia";
            };
          };
        }
      ];
    };

    nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
      inherit system pkgs specialArgs;
      modules = [
        { environment.etc."nixos-rebuild-target".text = "wsl\n"; }
        ./hosts/wsl
        ./modules/common.nix
        ./modules/ai.nix
        nixos-wsl.nixosModules.default
      ];
    };
  };
}
