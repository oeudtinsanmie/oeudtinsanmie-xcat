class xcat::params {
  
  $servicedefault = {
    ensure => running,
    hasstatus => true,
    hasrestart => true,
    enable => true,
    tag => "xcat-service",
  }
  
  case $::osfamily {
    'RedHat': {
      case $::operatingsystem {
        'CentOS': {
          $rmcmd = "/bin/rm"
          $cpcmd = "/bin/cp"
        }
        default: {
          $rmcmd = "rm"
          $cpcmd = "cp"
        }
      }
      if $lsbmajdistrelease == undef {
        $majrelease = $::operatingsystemmajrelease
      }
      else {
        $majrelease = $::lsbmajdistrelease
      }

      $xcatcore_mirror = 'http://sourceforge.net/projects/xcat/files/yum/2.8/xcat-core'
      $xcatdep_mirror  = "http://sourceforge.net/projects/xcat/files/yum/xcat-dep/rh${majrelease}/${architecture}"
      $key     = '/repodata/repomd.xml.key'
      $defaultrepo = {
        enabled  => 1,
        gpgcheck => 1,
        tag  => "xcatrepo",
      }
      $repos = {
        'xcat-2-core' => {
          descr => 'xCat 2 Core packages',
          baseurl => $xcatcore_mirror,
          gpgkey  => "${xcatcore_mirror}${key}",
        },
        'xcat-dep' => {
          descr => 'xCat 2 Core dependencies',
          baseurl => $xcatdep_mirror,
          gpgkey  => "${xcatdep_mirror}${key}",
        },
      }
      $service_list = { 
        "xinetd"  => {}, 
        "xcatd"   => {},
        "ipmi"    => {},
      }
    }
  }

  $pkg_list = [ 
	  "tftp-server.${architecture}", 
	  "xCAT.${architecture}",
	  "OpenIPMI.${architecture}",
	  "ipmitool",
  ]
  $pkg_exclude = [ "atftp-xcat.${architecture}" ]
  
  $firewalls = {
    '112 reject foward across vlans' => {
      chain => 'FORWARD',
      proto => 'all',
      action => 'reject',
    },
  }

}
