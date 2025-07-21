{
  pkgs,
  config,
  ...
}:
{

  services.tabby = {
    enable = true;
    #acceleration = "cpu"; #"cuda"; "null"
    model = "Mistral-7B";
    #port = 11029; # default is 11029
  };

  environment.systemPackages = with pkgs; [
    tabby-agent
    tabby
  ];

  networking.firewall = {
    allowedTCPPorts = [ 11029 ];
    #allowedUDPPorts = [ 11029 ];
  };

}
