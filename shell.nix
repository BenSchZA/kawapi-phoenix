{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  inherit (lib) optional optionals;

  elixir = beam.packages.erlangR21.elixir_1_7;
  nodejs = nodejs-10_x;
in

mkShell {
  buildInputs = [ elixir nodejs yarn git ]
    ++ optional stdenv.isLinux inotify-tools # For file_system on Linux.
    ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
      # For file_system on macOS.
      CoreFoundation
      CoreServices
    ]);

    shellHook = ''
      mix local.hex
      mix archive.install hex phx_new 1.4.10
      mix ecto.create
      mix phx.server
    '';
}