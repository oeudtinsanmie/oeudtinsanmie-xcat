define xcat::computer(
  $ensure       = present, 
  $hostname     = $title,
  $private_ip, 
  $private_mac, 
  $private_if, 
  $ipmi_ip       = undef, 
  $ipmi_mac      = undef, 
  $ipmi_user     = undef, 
  $ipmi_pw       = undef, 
  $master_ip,
  $xcat_groups   = [ 'ipmi', 'compute', 'all' ],
  $vcl_groups    = [ 'allComputers' ],
  $tgt_os, 
  $tgt_arch      = undef,
  $profile,
  $username      = 'root',
  $password,
  $netboot       = 'pxe',
  $provmethod    = 'install',
) {
  xcat_node { $hostname :
    ensure              => $ensure,
    groups              => $xcat_groups,
    ip                  => $private_ip,
    mac                 => $private_mac,
    bmc                 => "${hostname}-ipmi",
    bmcusername         => $ipmi_user,
    bmcpassword         => $ipmi_pw,
    mgt                 => "ipmi",
    installnic          => 'bootif',
    primarynic          => $private_if,
    netboot             => $netboot,
    os                  => $tgt_os,
    arch                => $tgt_arch,
    profile             => $profile,
    provmethod          => $provmethod,
    xcatmaster          => $master_ip,
    nfsserver           => $master_ip,
    domainadminuser     => $username,
    domainadminpassword => $password,
  }
  if $ipmi_ip != undef {
    if $ipmi_mac == undef {
      fail "\$ipmi_ip IP Address ${ipmi_ip} needs a mac address defined in \$ipmi_mac"
    }
    xcat_node {  "${hostname}-ipmi" :
      ensure  => $ensure,
      groups  => [ "all" ],
      ip      => $ipmi_ip,
      mac     => $ipmi_mac,
    }       
  }
}