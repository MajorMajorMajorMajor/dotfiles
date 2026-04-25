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

    dank-material-shell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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
        permittedInsecurePackages = [ "libsoup-2.74.3" ];
      };
    };
    specialArgs = { inherit inputs llm-agents llm-agents-pinned pkgs-unstable; };
  in {
    nixosConfigurations.feather-gnome = nixpkgs.lib.nixosSystem {
      inherit system pkgs specialArgs;
      modules = [
        { environment.etc."nixos-rebuild-target".text = "feather-gnome\n"; }
        ./hosts/feather
        ./modules/common.nix
        ./modules/desktop.nix
        ./modules/gnome.nix
        ./modules/gnome-circle.nix
        ./modules/gnome-extensions.nix
        ./modules/ai.nix
        nixos-hardware.nixosModules.microsoft-surface-pro-intel
      ];
    };

    nixosConfigurations.feather-niri = nixpkgs.lib.nixosSystem {
      inherit system pkgs specialArgs;
      modules = [
        { environment.etc."nixos-rebuild-target".text = "feather-niri\n"; }
        ./hosts/feather
        ./modules/common.nix
        ./modules/desktop.nix
        ./modules/gnome-circle.nix
        ./modules/niri.nix
        dank-material-shell.nixosModules.default
        ./modules/ai.nix
        nixos-hardware.nixosModules.microsoft-surface-pro-intel
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
