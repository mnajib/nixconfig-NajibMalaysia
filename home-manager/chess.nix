{
  inputs,
  outputs,
  #lib,
  config,
  pkgs,
  ...
}:
#let
#in
{
  #imports = [
  #];

  home.packages = with pkgs; [
    gnuchess                            # chess-engine
    stockfish                           # strong open source chess-engine
    fairymax                            # a small chess-engine supporting fairy pieces
    xboard                              # gui for chess-engine
    #eboard                              # chess interface for unix-like systems
    gnome.gnome-chess                   # gui chess game
    #kdePackages.knights                 # Chess board program
    cutechess                           # GUI, CLI, and library for playing chess
    uchess                              # play chess against UCI engines in your terminal
    gambit-chess                        # play chess in your terminal
    arena                               # Chess GUI for analyzing with and playing against various engines
    chessx                              # browse and analyse chess games
    chessdb                             # a free chess database

    gshogi                              # a GUI implementation of the Shogi board game (also known as Japanese Chess)
  ];

}
