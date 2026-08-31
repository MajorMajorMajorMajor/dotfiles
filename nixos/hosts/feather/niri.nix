{ inputs, ... }: {
  imports = [
    ../../modules/niri.nix
    ../../modules/niri-dms.nix
    inputs.dank-material-shell.nixosModules.default
  ];
}
