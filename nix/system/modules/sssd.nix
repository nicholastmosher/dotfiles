{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    krb5
    samba
  ];

  networking = {
    search = [ "geisel.io" ];
    hosts = {
      "192.168.0.12" = [ "geisel.io" ];
    };
  };

  services.syslogd.enable = true;
  services.sshd.enable = true;
  security.pam.services = {
    login.makeHomeDir = true;
    sshd.makeHomeDir = true;
  };

  services.sssd = {
    enable = true;
    config = ''
debug_level=9

[sssd]
debug_level=9
config_file_version=2
reconnection_retries=3
services=nss,pam,sudo
domains=geisel.io

[domain/geisel.io]
debug_level=9
id_provider=ipa
access_provider=ipa
ipa_domain=geisel.io
ipa_server=ipa01.geisel.io
ipa_hostname=black-pearl.geisel.io
dyndns_update=true
    '';
  };
}

