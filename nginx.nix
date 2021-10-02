{ config, ... }: {

  services.nginx = {
    enable = true;
    # Use recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    user = "leznom";
    virtualHosts."leznom.com.ar" = {
      enableACME = true;
      forceSSL = true;  
      root = "/var/www/pure";
      extraConfig = ''
      index    blog.html;
      '';
    };
  };

  security.acme.acceptTerms = true;
  security.acme.email = "angelgmthirty@gmail.com";

  systemd.services.nginx.serviceConfig = {
    ReadWritePaths = [ "/var/log/nginx/" "/var/www/" ];
  };

}
