{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    apostrophe
    authenticator
    chess-clock
    fretboard
    errands
    eyedropper
    drum-machine
    gradia
    graphs
    identity
    iotas
    junction
    keypunch
    gnome-mahjongg
    komikku
    mousai
    newsflash
    gnome-obfuscate
    pika-backup
    resources
    gnome-secrets
    shortwave
    solanum
    gnome-pomodoro
    gnome-sudoku
    tangram
    textpieces
    valuta
    warp
    wike
    wordbook
  ];
}
