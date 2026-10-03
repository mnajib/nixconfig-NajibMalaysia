{
  pkgs,
  config,
  lib,
  ...
}:{

  # ─── Limit to 1080p, prefer H.264 30fps (the only codec this GPU decodes) ───
  # config : home-manager option, written to ~/.config/mpv/mpv.conf
  # Choices (separated by "/", first that works is used):
  #   1) <=1080p, <=30fps, H.264 (avc1)
  #   2) <=1080p, <=30fps, not AV1
  #   3) fallback: <=1080p anything
  #programs.mpv.config.ytdl-format = lib.mkForce "bestvideo[height<=?1080][fps<=?30][vcodec^=avc1]+bestaudio/bestvideo[height<=?1080][fps<=?30][vcodec!^=av01]+bestaudio/best[height<=?1080]";
  #programs.mpv.config.ytdl-format = lib.mkForce "bestvideo[height<=?720][fps<=?30][vcodec^=avc1]+bestaudio/bestvideo[height<=?720][fps<=?30][vcodec!^=av01]+bestaudio/best[height<=?720]";
  programs.mpv.config.ytdl-format = lib.mkForce "bestvideo[height<=?720]+bestaudio/best[height<=?720]";

  # vaapi = ask the Intel GPU to decode. Comment out to turn off.
  programs.mpv.config.hwdec = lib.mkForce "vaapi";

  programs.qutebrowser = {
    enable = true;

    # Uncomment if you want :set results saved in autoconfig.yml to be loaded
    #loadAutoconfig = true;

    keyBindings = {
      # Press 'M' to open the current page in mpv (guna lalai mpv.conf = 720p)
      normal."M" = lib.mkForce "spawn mpv {url}";

      # Press ',M' to open the current page in mpv at 1080p H.264 30fps
      #normal.",M" = "spawn mpv --ytdl-format='bestvideo[height<=?1080][fps<=?30][vcodec^=avc1]+bestaudio' {url}";
      normal.",M" = lib.mkForce "hint links spawn mpv --ytdl-format='bestvideo[height<=?1080][fps<=?30][vcodec^=avc1]+bestaudio' {hint-url}";

      # Press ',m' to select a YouTube link on screen and open it in mpv
      normal.",m" = lib.mkForce "hint links spawn mpv {hint-url}";

    };

    # ─── Selected-script blocker ──────────────────────────────────────
    # Code lives in ./qutebrowser/qbcfg (linked by xdg.configFile below).
    # Comment out the last two Python lines to disable the blocker.
    extraConfig = ''
      # sys : Python stdlib; sys.path = folders Python imports from
      import sys
      sys.path.insert(0, str(config.configdir))

      # Single source of truth for the rules location (writable, NOT in Nix store)
      RULES_FILE = config.configdir / "data" / "blocked-scripts.txt"

      from qbcfg import blocker
      blocker.setup(config, RULES_FILE)
    '';

  };

}
