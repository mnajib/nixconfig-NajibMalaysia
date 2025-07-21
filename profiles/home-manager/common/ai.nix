# home-manager/ai.nix
# This module configures the Continue VSCode extension to use local Ollama and Tabby services
# It validates that the selected Ollama model is present in the system's declared ollama models
#
# NOTE:
#  Example usage; in Home-Manager ,home.nix:
#    {
#      imports = [
#        ./home-manager/ai.nix
#      ];
#    }
#

{ config, lib, pkgs, ... }:

let
  # Customizable model names for Continue to use
  ollamaModel = config.ai.ollamaModel or "codellama";
  tabbyModel = config.ai.tabbyModel or "TabbyML/DeepSeek-Coder-6.7B-instruct";
  tabbyApiKey = "sk-tabby-placeholder";  # Tabby does not require auth, but Continue expects a key field

  # Ensure selected ollama model is listed in the system's ollama service config
  validateOllamaModel = builtins.elem ollamaModel config.services.ollama.models;

in
{
  # Define options to allow users to override default models
  options.ai.ollamaModel = lib.mkOption {
    type = lib.types.str;
    default = "codellama";
    description = "Default Ollama model used by Continue.";
  };

  options.ai.tabbyModel = lib.mkOption {
    type = lib.types.str;
    default = "TabbyML/DeepSeek-Coder-6.7B-instruct";
    description = "Default Tabby model name (for reference or matching system config).";
  };

  config = {
    # Warn the user during evaluation if the selected model is not available
    assertions = [
      {
        assertion = validateOllamaModel;
        message = ''
          The selected Ollama model "${ollamaModel}" is not listed in `services.ollama.models`.
          Please ensure it is defined in your system configuration to avoid mismatch.
        '';
      }
    ];

    # Generate Continue's config file only if validation passes
    home.file.".continue/config.json".text = builtins.toJSON {
      models = {
        ollama = {
          provider = "ollama";
          baseUrl = "http://localhost:11434";
          model = ollamaModel;
        };
        tabby = {
          provider = "openai";
          apiBase = "http://localhost:11029/v1";
          apiKey = tabbyApiKey;
        };
      };
      defaultModel = "ollama";
      contextProviders = [ "terminal" "fileSystem" "tabby" ];
    };
  };

} # End let ... in { ... }
