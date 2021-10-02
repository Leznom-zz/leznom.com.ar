{ config, ... }:

{
  ##
  # Firewall
 
   # Set hostname
  networking.hostName = "racknerd-97a72c";
   # Activate Firewall
  networking.firewall.enable = true;
   # Allow ports access
  networking.firewall.allowedTCPPorts = [ 315 80 53 443 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
   # Enable access to ping command
  networking.firewall.allowPing = true;
  

  ##
  # Enable BBR module

  boot.kernelModules = [ "tcp_bbr" ];

   # Network hardening and performance
  boot.kernel.sysctl = {
     # Disable magic SysRq key
    "kernel.sysrq" = 0;
     # Ignore ICMP broadcasts to avoid participating in Smurf attacks
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
     # Ignore bad ICMP errors
    "net.ipv4.icmp_ignore_bogus_error_responses" = 1;
     # Reverse-path filter for spoof protection
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.conf.all.rp_filter" = 1;
     # SYN flood protection
    "net.ipv4.tcp_syncookies" = 1;
     # Do not accept ICMP redirects (prevent MITM attacks)
    "net.ipv4.conf.all.accept_redirects" = 0;
    "net.ipv4.conf.default.accept_redirects" = 0;
    "net.ipv4.conf.all.secure_redirects" = 0;
    "net.ipv4.conf.default.secure_redirects" = 0;
    "net.ipv6.conf.all.accept_redirects" = 0;
    "net.ipv6.conf.default.accept_redirects" = 0;
     # Do not send ICMP redirects (we are not a router)
    "net.ipv4.conf.all.send_redirects" = 0;
     # Do not accept IP source route packets (we are not a router)
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;
     # Protect against tcp time-wait assassination hazards
    "net.ipv4.tcp_rfc1337" = 1;
     # TCP Fast Open (TFO)
    "net.ipv4.tcp_fastopen" = 3;
     ## Bufferbloat mitigations
     # Requires >= 4.9 & kernel module
    "net.ipv4.tcp_congestion_control" = "bbr";
     # Requires >= 4.19
    "net.core.default_qdisc" = "cake";
  };


  ##
  # SSH Configuration
 
   # Enable SSH 
  services.openssh.enable = true;
   # Disable passwordless SSH
  services.openssh.passwordAuthentication = false;
  services.openssh.ports = [ 315 ];
   # Users with SSH access
  users.users.leznom.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCxjVzDRULSUeP6w36JSLOIPZ4iNkCePMWXKE3pugVH00F1TftoRFFYwW1qGhtunc5N5J2q9GseBGfED1xnQ4j2vKM/MBRSlD6RyUrlhFAYbMPoKbRHUggjwFgWfVKaOm09lqPpRmno8a5T1jKGiMUISXBnorItTvo5CWQ4nStdJE/DxGAPMYMG0olvjTY734EvqhQkDYl4GtF41ltgLGPQnrgeAAY7h1wkyV65jMK6LNU0JN/66s9g2WXEk//fECy5LaT+8DranEAjxWNy9/PKBQwmdcNSlwA1lNRHJ+cTdNEZSN+uYePZ9aJ1ehTqt+VBRueLU3nVvywRy8K2u+cwlUsZYReY88H1xYZNQYFlF6IDEYegnX8ou53I/5lLbwd3ld44uxvNqw3tIS9CGSTPekNoH0438oiP4JbR7OWROguUKDyntDF0IqCcwacHRFU1cusxoqpBIfJlGD9oN1b/T28j9GRw0FIfSdnueTVTSk0tDvu1Ay8prZRG9VLS2kc= angel@Saturn" 
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCy/kxy8dwy2cdDdEt5LHpvyJUJqVSeWTzTAKZLUih78WpC60KYwYw3Vg1D5+4/M3hCw6vaFrAPnXzpS6CyusxDd5W0D8AenCvwk3IdjOCLS8APLrCCGWeJm/Mb3oEf73fxIPhjAEnEvl/PxifR1LU693bOtSlwzfmGhmq7NlltevNogin2Gp/OTXGY3QFuL5AYldunTexqVihTEaOPakNAxhfyO8kyDx1C7fJBIpCmveFt4nDI9Y2pi3lbOKDxfEc4WKNHpkBv3azFz90jFIUpACAkv04hV2Exwvqtgq3hBIK+a0WbfOYr5bPLvMh7jnwTQitY/mP6IRk4KMV7Ioc7dj3fQeEuKj9EO4bxveoF+Tk8BrpOX3SwBnykECz4m7Dd/y7QVnhe4HsgfNDzQjZmLgAKW24I1tYJM5grKYreWCIGfy3OaRsk5NDzco+wq19yA9iW5RoafPpWJREYynWmzR5NDx6vtkoMbVd/SGTfYFd6UKCcxHoNpJDxGk8H8Cc= leznom@isreal"
  ];


  ##
  # BIND
  services.bind = {
     # Enable Bind tool
    enable = true;
    extraConfig = ''
      include "/var/lib/secrets/dnskeys.conf";
    '';
    ipv4Only = true;
    zones = [
      rec {
        name = "leznom.com.ar";
        file = "/var/db/bind/${name}";
        master = true;
        extraConfig = "allow-update { key tpkey.leznom.com.ar.; };";
      }
    ];
  }; 
}
