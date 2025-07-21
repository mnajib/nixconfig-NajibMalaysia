{ pkgs, config, ... }:
{
  services.inspircd = {
    enable = true;

    config = ''
    <config format="xml">

    #<include file="example.conf">

    <server
      id="001"
      name="AbuNaqibIRCServer"
      description="AbuNaqib Private IRC Server"
    >

    <bind
      #address="0.0.0.0"
      port="6667"
      type="clients"
      defer="0s"
      free="no"
    >

    # Step-1: Generate a private key:
    #   openssl genrsa -out /etc/inspircd/ssl.key 2048
    #   That will create the '/etc/inspircd/ssl.key' file.
    #
    # Step-2: Generate a certificate-signing-request (CSR):
    #   openssl req -new -key /etc/inspircd/ssl.key -out /etc/inspircd/ssl.csr
    #   This will prompt you enter some information.
    #   It will create the '/etc/inspircd/ssl.csr' file.
    #
    # Step-3: Generate a self-signed certificate:
    #   openssl x509 -req -days 365 -in /etc/inspircd/ssl.csr -signkey /etc/inspircd/ssl.key -out /etc/inspircd/ssl.crt
    #   That will create the '/etc/inspircd/ssl.crt' file.
    #

    #<ssl enable="true" cert="/etc/inspircd/ssl.crt" key="/etc/inspircd/ssl.key">

    <admin name="admin" email="admin@example.com">
    #<oper name="oper" password="oper_password" host="*">

    #<module name="account">
    #<module name="admin">
    #<module name="auth">
    #<module name="ban">
    #<module name="casemapping">

    #<module name="help">
    #<include file="help.conf">

    #<module name="log_syslog">
    #<log
    #  method="file"
    #  target="ircd.log"
    #  type="* -USERINPUT -USEROUTPUT"
    #  level="default"
    #  flush="20"
    #>

    #<module name="host">
    #<module name="register">
    #<module name="stats">
    #<module name="user">
    #<module name="vhost">
    #<module name="ssl_gnutls">
    '';

    #options = [];
  };

  ##environment.etc."inspircd.conf".txt = ''
  #environment.etc.inspircd."inspircd.conf".txt = ''
  #'';

  #environment.systemPackages = with pkgs; [
  #  #pulseaudioFull
  #];

  networking.firewall.allowedTCPPorts = [ 6667 ];
}
