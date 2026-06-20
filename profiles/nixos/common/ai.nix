# nixos/ai.nix

{
 pkgs,
 config,
 lib,
 ...
}:

{

  environment.systemPackages = with pkgs; [
    #ollama
    aichat
    kdePackages.alpaka
  ]; # End environment.systemPackages = with pkgs;

  services.ollama = {
    enable = false; #true;
    package = pkgs.unstable.ollama; # from overlay

    host = "0.0.0.0"; #host = ""; # default "127.0.0.1"
    port = 11434; # default 11434
    #listenAddress = ...

    #home = "";

    #
    #  NOTE:
    #
    #    To find out whether a model is running on CPU or GPU, you can either look at the logs of
    #
    #      $ ollama serve
    #
    #    and search for "looking for compatible GPUs" and "new model will fit in available VRAM in single GPU, loading".
    #
    #    or while a model is answering run in another terminal
    #
    #      NAME         ID              SIZE      PROCESSOR    UNTIL
    #      gemma3:4b    c0494fe00251    4.7 GB    100% GPU     4 minutes from now
    #
    #    In this example we see "100% GPU".
    #
    #acceleration = false; # disable GPU, only use CPU
    acceleration = "cuda"; # supported by most modern NVIDIA GPUs
    #acceleration = "rocm"; # supported by most modern AMD GPUs

    #models = "llama3.2:3b";
    #models = "codellama:13b";

    # Optional: preload models, see https://ollama.com/library
    loadModels = [
      #"llama3.2:3b"
      #"deeepseek-r1:1.5b"
      #"codellama:13b" # Optional preload
    ];

    openFirewall = true;

  }; # End services.ollama

  services.open-webui = {
    enable = false; #true;
  };


  services.tabby = {
    enable = true;
    #package = pkgs.unstable.tabby;

    host = "0.0.0.0"; #host = ""; # default "127.0.0.1"
    port = 11029; # default 11029

    acceleration = "cuda";

    # See for Model Options: https://github.com/TabbyML/registry-tabby
    #model = "TabbyML/DeepSeek-Coder-6.7B-instruct";
    model = "TabbyML/StarCoder-1B"; # Main completion model

  }; # End services.tabby

  # Manually create the config.toml in the expected location
  environment.etc."tabby/config.toml".text = ''
    [model.chat.local]
    model_id = "TabbyML/Qwen2-1.5B-Instruct"
  '';

  # Consolidated ExecStart
  # Note: Removed the separate tabby-scheduler service entirely.
  # The 'serve' command in 0.28.0 handles indexing automatically.
  #systemd.services.tabby.serviceConfig.ExecStart = lib.mkForce
  #  "${pkgs.tabby}/bin/tabby serve --port 11029 --model TabbyML/StarCoder-1B --chat-model Qwen2-1.5B-Instruct";
  #
  systemd.services.tabby = {
    serviceConfig = {
      # 1. Remove the --config flag from ExecStart
      ExecStart = lib.mkForce
        "${pkgs.tabby}/bin/tabby serve --port 11029 --model TabbyML/StarCoder-1B --chat-model Qwen2-1.5B-Instruct";

      # 2. Add a preStart script to symlink the Nix-managed config into the state dir
      # This ensures Tabby finds the TOML file where it expects it.
      ExecStartPre = pkgs.writeShellScript "tabby-setup" ''
        mkdir -p /var/lib/tabby
        ln -sf /etc/tabby/config.toml /var/lib/tabby/config.toml
      '';
    };
  };

  # data is persistent in /var/lib/tabby
  # To reset credential (user & password)
  #rm /var/lib/tabby/tabby.db
  #
  # How to Force a Password Reset / New Setup
  # If the Web UI is asking for a password you don't have, or if you want to trigger the "First-Run" setup again to define your email/password:
  # Stop the service:
  #   systemctl stop tabby
  #
  # Backup/Remove the database:
  #   mv /var/lib/tabby/ee/dev-db.sqlite /var/lib/tabby/ee/dev-db.sqlite.old
  #
  # Restart the service:
  # systemctl start tabby
  #
  # When you refresh http://nyxora:11029, it should now treat you as a new user and ask you to create your admin credentials.

  networking.firewall = {
    allowedTCPPorts = [
      8080 # webui
      11029 # tabby
      11434 # ollama
    ];
    allowedUDPPorts = [
      #8080 # webui
      11029 # tabby
      11434 # ollama
    ];
  };

}
