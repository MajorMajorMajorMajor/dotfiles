{ inputs, ... }: {
  imports = [
    ../../modules/niri.nix
    inputs.dank-material-shell.nixosModules.default
  ];
}
