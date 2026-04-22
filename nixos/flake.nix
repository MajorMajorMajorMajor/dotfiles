{
    description = "Surface Pro NixOS";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
        nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    };

    outputs = { self, nixpkgs, nixos-hardware, ... }:
    let
        system = "x86_64-linux";
    in {
        nixosConfigurations.surface = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
                ./configuration.nix
                ./hardware-configuration.nix

                nixos-hardware.nixosModules.microsoft-surface-pro-intel

                ({ pkgs, ...}: {
                    nix.settings.experimental-features = [ "nix-command" "flakes" ];
                    nix.settings.substituters = [
                        "https://cache.nixos.org"
                        "https://linux-surface.cachix.org"
                        "https://surface-nix.cachix.org"
                    ];
                    nix.settings.trusted-public-keys = [
                        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                        "linux-surface.cachix.org-1:dorigzlDDV6AacaQLVHHYU8scAzBIlwAhGz/JQ8fVeI="
                        "surface-nix.cachix.org-1:RsYTWm0eGHpJO6FBL9l/pZMHBYHcI9siaPVNM2oHD+8="
                    ];

                    # microsoft-surface.ipts.enable = true;  # touchscreen

                    environment.systemPackages = with pkgs; [
                        vim
                        git
                        baobab
                    ];
                })
            ];
        };
    };
}
