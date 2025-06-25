{ pkgs, config, ... }:
# nixos/ai.nix

{

  environment.systemPackages = with pkgs; [
    ollama
    aichat
    kdePackages.alpaka
  ]; # End environment.systemPackages = with pkgs;

  services.ollama = {
    enable = true;

    #host = ""; # default "127.0.0.1"
    port = 11434; # default 11434
    #listenAddress = ...

    #package = ...;

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

  services.tabby = {
    enable = true;

    #host = ""; # default "127.0.0.1"
    port = 11029; # default 11029

    # See for Model Options: https://github.com/TabbyML/registry-tabby
    #model = "TabbyML/DeepSeek-Coder-6.7B-instruct";
  }; # End services.tabby

}
