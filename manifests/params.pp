class xcat::params {
  
  case $::osfamily {
    'RedHat': {
      $xcatcore_mirror = 'http://sourceforge.net/projects/xcat/files/yum/2.8/xcat-core'
      $xcatdep_mirror  = "http://sourceforge.net/projects/xcat/files/yum/xcat-dep/rh${lsbmajdistrelease}/${architecture}"
      $key     = '/repodata/repomd.xml.key'
      $defaultrepo = {
        enabled  => 1,
        gpgcheck => 1,
        tag  => "xcatrepos",
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
    }
  }

  $pkg_list = [ 
	  "tftp-server.${architecture}", 
	  "xCAT.${architecture}",
	  "OpenIPMI.${architecture}",
	  "ipmitool",
  ]
  $pkg_exclude = [ "atftp-xcat.${architecture}" ]

}
