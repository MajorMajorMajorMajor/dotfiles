{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Writing and notes
    apostrophe
    iotas
    keypunch
    textpieces
    wordbook

    # Security and identity
    authenticator
    identity
    gnome-secrets
    gnome-obfuscate

    # Utilities and productivity
    baobab
    errands
    eyedropper
    junction
    pika-backup
    resources
    solanum
    valuta

    # Media and creative
    drum-machine
    fretboard
    gradia
    komikku
    mousai
    shortwave

    # Data, learning, and reference
    gitg
    graphs
    newsflash
    wike

    # Games
    chess-clock
    gnome-mahjongg
    gnome-sudoku
    tangram

    # Networking
    warp
  ];
}
