define xcat::pod(
  $ensure = present,
  $private_hash, 
  $ipmi_hash = undef, 
  $defaults = undef, 
  $nodes = undef,
) {
  if $private_hash == undef or $private_hash['master_if'] == undef {
    fail "vclmgmt::pod ${name} requires \$master_if to be defined in \$private_hash"
  }
  if $private_hash['master_ip'] == undef {
    fail "vclmgmt::pod ${name} requires \$master_ip to be defined in \$private_hash"
  }
  if $private_hash['master_mac'] == undef {
    fail "vclmgmt::pod ${name} requires \$master_mac to be defined in \$private_hash"
  }
  
  ensure_resource(xcat::network, $name, merge($private_hash, { ensure => $ensure, }) )
  if $ipmi_hash != undef and $ipmi_hash['master_if'] != undef {
    if $ipmi_hash['master_ip'] == undef {
      fail "vclmgmt::pod ${name} requires \$master_ip to be defined in \$ipmi_hash"
    }
    if $ipmi_hash['master_mac'] == undef {
      fail "vclmgmt::pod ${name} requires \$master_mac to be defined in \$ipmi_hash"
    }
    ensure_resource(xcat::network, "${name}-ipmi", merge($ipmi_hash, { ensure => $ensure, }) )
  }
  $tmphash = {
    master_ip => $private_hash[master_ip],
    ensure => $ensure,
  }

  if $defaults == undef {
    $mydefaults = $tmphash
  }
  else {
    $mydefaults = merge($tmphash, $defaults)
  }

  if $nodes != undef {
    create_resources(xcat::computer, $nodes, $mydefaults)
  }
}