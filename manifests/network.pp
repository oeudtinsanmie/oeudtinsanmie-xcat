define xcat::network(
  $buildphase = "start",
  $ensure = present,
  $master_if, 
  $master_mac, 
  $master_ip, 
  $vlan_alias_ip  = undef, 
  $domain, 
  $network, 
  $netmask, 
  $vlanid         = undef,
) {
  $default = {
    ensure      => $ensure,
    nameservers => $master_ip,
    dhcpserver  => $master_ip,
    tftpserver  => $master_ip,
    domain      => $domain,
    net         => $network,
    mask        => $netmask,
  }
  $xcatmask = split($netmask, '\.')
  $mgtifname = $master_if

  if $vlan_alias_ip == undef {
    $xcatnet = split($master_ip, '\.')
    
    $add_interface = $master_if
    $gateway = $master_ip
  }
  else {
    $xcatnet = split($vlan_alias_ip, '\.')
    if $buildphase == "start" {
	    network::if::static { "${master_if}.${vlanid}" :
	      ensure      => 'up',
	      ipaddress   => $vlan_alias_ip,
	      netmask     => $netmask,
	      macaddress  => $master_mac,
	      vlan        => true,
	      domain      => $domain,
	    }
    }
    $add_interface = "${master_if}.${vlanid}"
    
    $gateway = $vlan_alias_ip 
  }     
  $nethash = {
    "${domain}" => {
      mgtifname   => $mgtifname,
      vlanid      => $vlanid,
      gateway     => $gateway,
    },
    "${xcatnet[0]}_${xcatnet[1]}_${xcatnet[2]}_0-${xcatmask[0]}_${xcatmask[1]}_${xcatmask[2]}_${xcatmask[3]}" => {
      ensure => absent,
    }
  }
  
  create_resources(xcat_network, $nethash, $default)
  
  Xcat_site_attribute <| title == 'dhcpinterfaces' |> {
    value +> $add_interface,
  }
}