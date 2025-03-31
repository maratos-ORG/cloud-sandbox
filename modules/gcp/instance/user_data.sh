#!/usr/bin/env bash

function line_in_ssh_conf {
  grep -q "$1" /etc/ssh/sshd_config && sed -i "s|$1 .*|$1 $2|g" /etc/ssh/sshd_config || echo "$1 $2" >> /etc/ssh/sshd_config
  cat /etc/ssh/sshd_config | grep "$1" # Debug
}

line_in_ssh_conf PermitRootLogin no
line_in_ssh_conf PubkeyAuthentication yes
line_in_ssh_conf PasswordAuthentication no

function get_my_ip {
  local ip=""
  if [[ "${hostname_use_public_ip}" == "true" ]]; then # get host public ip (if the host is behind NAT it will be NAT IP)
    # Try via icanhazip.com
    ip=`curl --retry 3 --connect-timeout 2 -4 -s icanhazip.com.`
    if [[ -z "$ip" ]]; then # Try via api.ipify.org as a fallback
      ip=`curl --retry 3 --connect-timeout 2 -s api.ipify.org.`
    fi
  else # get host private ip
    ip=`curl -H 'Metadata-Flavor: Google' http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip`
  fi
  echo "$ip" | sed s/[.]/-/g
}

# shellcheck disable=SC2154
hostnamectl set-hostname "${hostname_base}-$(get_my_ip)"

systemctl restart sshd

${additional_user_data}
