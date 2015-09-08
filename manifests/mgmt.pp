
define xcat::mgmt(
  $private_mac,
  $private_if, 
  $private_ip,  
  $private_domain, 
  $ipmi_mac      = undef,
  $ipmi_if       = undef,  
  $ipmi_ip       = undef, 
  $system_user   = 'root',
  $system_pw,
  $poddefaults   = {},
  $pods          = undef,
  $firewalldefaults = { },
) {

  ######### Network Interfaces #############
  if $ipmi != undef {
    $ifaces = {
	    "${private_if}" => {
	      ipaddress => $private_ip,
	      macaddress => $private_mac,
	    },
	    "${ipmi_if}" => {
	      ipaddress => $ipmi_ip,
	      macaddress => $ipmi_mac,
	    },
	  }
  } else {
    $ifaces = {
      "${private_if}" => {
        ipaddress => $private_ip,
        macaddress => $private_mac,
      },
    }
  }
  create_resources(network::if::static, $ifaces, {
    ensure => 'up',
    netmask   => '255.255.255.0',
  })
    
  ############# xCAT ####################
  create_resources(firewall, $xcatfirewalls, $firewalldefaults)
  
  $privatenet = split($private_ip, '\.')
  xcat_network { "${privatenet[0]}_${privatenet[1]}_${privatenet[2]}_0-255_255_255_0":
    ensure => absent,
  }
  if ipmi_ip != undef {
    $ipminet = split($ipmi[ipaddress], '\.')
    xcat_network { "${ipminet[0]}_${ipminet[1]}_${ipminet[2]}_0-255_255_255_0":
      ensure => absent,
    }      
  }
  
  xcat_site_attribute { "master" :
    sitename => 'clustersite',
    value => $fqdn,
  }
  
  xcat_site_attribute { "nameservers" :
    sitename => 'clustersite',
    value => $private_ip,
  }
  
  xcat_site_attribute { "dhcpinterfaces" :
    sitename => 'clustersite',
    value => [],
  }
  
  xcat_site_attribute { "domain" :
    sitename => 'clustersite',
    value => $private_domain,
  }
  
  xcat_site_attribute { "ntpservers" :
    sitename => 'clustersite',
    value => 'time.ncsu.edu',
  }
  
  xcat_site_attribute { "xcatroot" :
    sitename => 'clustersite',
    value => "/opt/xcat",
  }
  
  xcat_passwd_tbl { "system" :
    username => $system_user,
    password => $system_pw,
  }
  
  xcat_site_attribute  { "xcatprefix" :
    sitename => 'clustersite',
    value => "/opt/xcat",
  }  
  exec { "makehosts" :
    command => "/opt/xcat/sbin/makehosts",
    refreshonly => "true",
  }~>
  exec { "rmleases":
    command => "${xcat::params::rmcmd} -rf /var/lib/dhcpd/dhcpd.leases",
    refreshonly => "true",
  }~>   
  exec { "makedhcpn" :
    command => "/opt/xcat/sbin/makedhcp -n",
    refreshonly => "true",
  }~>
  exec { "makedhcpa" :
    command => "/opt/xcat/sbin/makedhcp -a",
    refreshonly => "true",
  }~>
  exec { "makedns"  :
    command => "/opt/xcat/sbin/makedns -n",
    refreshonly => "true",
  }

  # Chain declarations for xcat resources
  Exec["makehosts"] <~ Xcat::Computer <| |>
  Exec["makehosts"] <~ Xcat::Pod <| |>
  Exec["makedns"] ~> Service["xcatd"]

  ########### Security
  # set up firewalls
  
  $myfirewalls = {
	  '110 accept forward from me across bridges' => {
	    chain => 'FORWARD',
	    proto => 'all',
	    action => 'accept',
	    source => $private_ip,
	  },
    "115 accept tftp" => {
	    chain => 'INPUT',
	    proto => 'udp',
	    dport => 69,
	    action => 'accept',
	    destination => $private_ip,
	  },
    "116 accept sending tftp" => {
	    chain => 'INPUT',
	    proto => 'udp',
	    dport => 69,
	    action => 'accept',
	    source => $private_ip,
    },
  }
  
  $xcatfirewalls = {
    "117 accept xcat calls 3001" => {
      chain => 'INPUT',
      proto => 'tcp',
      dport => 3001,
      action => 'accept',
      destination => $private_ip,
    },
    "118 accept xcat calls 3002" => {
      chain => 'INPUT',
      proto => 'tcp',
      dport => 3002,
      action => 'accept',
      destination => $private_ip,
    },
  }

  $firewalls = merge($xcat::params::firewalls, $myfirewalls) 
  create_resources(firewall, $firewalls, $firewalldefaults)
  
  ################ Pods
  # declare any pods included in class declaration
  if $pods != undef {
    $masterdefault = {
      private_if    => $private_if,
      private_ip    => $private_ip,
      private_mac   => $private_mac,
      ipmi_if       => $ipmi_if,
      ipmi_ip       => $ipmi_ip,
      ipmi_mac      => $ipmi_mac,
      system_user   => $system_user,
      system_pw     => $system_pw,
    }
    $newpods = set_xcatpod_defaults($pods, $poddefaults, $masterdefault)
    create_resources(vclmgmt::pod, $newpods)
  }
    
}