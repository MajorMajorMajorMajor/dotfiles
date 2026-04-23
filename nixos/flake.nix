{
  description = "NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
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
  };

  outputs = { 
    self, 
    nixpkgs, nixpkgs-unstable, 

    nixos-hardware, 
    nixos-wsl, 

    llm-agents,
    llm-agents-pinned,
    ...
  } @ inputs:
  let
    system = "x86_64-linux";
    pkgs-unstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
    specialArgs = { inherit inputs llm-agents llm-agents-pinned pkgs-unstable; };
  in {
    nixosConfigurations.feather = nixpkgs.lib.nixosSystem {
      inherit system specialArgs;
      modules = [
        ./hosts/feather
        ./modules/common.nix
        ./modules/desktop.nix
        ./modules/gnome-circle.nix
        ./modules/gnome-extensions.nix
        ./modules/ai.nix
        nixos-hardware.nixosModules.microsoft-surface-pro-intel
      ];
    };

    nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
      inherit system specialArgs;
      modules = [
        ./hosts/wsl
        ./modules/common.nix
        ./modules/ai.nix
        nixos-wsl.nixosModules.default
      ];
    };
  };
}
