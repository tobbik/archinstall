#!/bin/bash

function add_match() {
  local nw_file_name=$1
  local if_name=$2
  printf "[Match]
Name=${if_name}

"  > ${nw_file_name}
}

function add_nw() {
  local nw_file_name=$1
  local ign_carr_loss=$2
  local dhcp=$3
  printf "[Network]\n"                            >> ${nw_file_name}
  if [ x"$dhcp" != x"" ]; then
    printf "DHCP=true\n"                          >> ${nw_file_name}
  fi
  printf "DNSSEC=false
UseDomains=true
IgnoreCarrierLoss=${ign_carr_loss}

" >> ${nw_file_name}
}

function add_addr() {
  local nw_file_name="$1"
  local addr=$2
  printf "[Address]\n"          >> ${nw_file_name}
  printf "Address=${addr}\n\n"  >> ${nw_file_name}
}

function add_dhcp() {
  local nw_file_name="$1"
  local routemetric=$2
  printf "
[DHCPv4]
RouteMetric=${routemetric}

[IPv6AcceptRA]
RouteMetric=${routemetric}

"  >> ${nw_file_name}
}

function add_disable() {
  local nw_file_name="$1"
  printf "
[Link]
RequiredForOnline=no
ActivationPolicy=manual
" >> ${nw_file_name}
}


function main() {
  local if_name=$1
  local ipv4=$2
  local ipv6=$3
  local ignore_carrier_loss=$([[ $if_name = w* ]] && echo "7s" || echo "2s")
  local route_metric=$([[ $if_name = w* ]] && echo "600" || echo "100")
  local dhcp=
  if [ x"$ipv4" == x"" ] && [ x"$ipv6" == x"" ]; then
    dhcp=true
  fi
  local nw_file_name="/etc/systemd/network/${if_name}.network"
  #local nw_file_name="./${if_name}.network"
  add_match "${nw_file_name}" "${if_name}"
  add_nw    "${nw_file_name}" "${ignore_carrier_loss}" "${dhcp}"
  if [ x"${ipv4}" != x"" ]; then
    add_addr ${nw_file_name} ${ipv4}
  fi
  if [ x"${ipv6}" != x"" ]; then
    add_addr ${nw_file_name} ${ipv6}
  fi
  if [ x"$dhcp" != x"" ]; then
    add_dhcp ${nw_file_name} ${route_metric}
  fi
}

main $@
