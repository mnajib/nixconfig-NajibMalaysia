{
  # Ref:
  # https://nixos.wiki/wiki/Encrypted_DNS
  #
  # Example configuration for Cloudflare.
  #
  # Note that digests change and need to be updated.
  # To update digests get the TLS certificate that signs the responses and calculate the digest:
  # echo | openssl s_client -connect '1.1.1.1:853' 2>/dev/null | openssl x509 -pubkey -noout | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64
  # Or using kdig from knot-dns
  # kdig -d @1.1.1.1 +tls-ca +tls-host=one.one.one.one example.com

  services.stubby = {
    enable = true;
    settings = pkgs.stubby.passthru.settingsExample // {
      upstream_recursive_servers = [{
        address_data = "1.1.1.1";
        tls_auth_name = "cloudflare-dns.com";
        tls_pubkey_pinset = [{
          digest = "sha256";
          value = "GP8Knf7qBae+aIfythytMbYnL+yowaWVeD6MoLHkVRg=";
        }];
      } {
        address_data = "1.0.0.1";
        tls_auth_name = "cloudflare-dns.com";
        tls_pubkey_pinset = [{
          digest = "sha256";
          value = "GP8Knf7qBae+aIfythytMbYnL+yowaWVeD6MoLHkVRg=";
        }];
      }];
    };
  };
}
