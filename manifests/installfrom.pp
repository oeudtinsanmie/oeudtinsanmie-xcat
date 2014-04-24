class xcat::installfrom {
    include xcat::params

    yumrepo { $xcat::params::xcatcore :
        descr => $xcat::params::xcatcore_desc,
        baseurl => $xcat::params::xcatcore_mirror,
        enabled => 1,
	gpgcheck => 1,
	gpgkey => $xcat::params::xcatcore_key,
        require => Class["xcat::params"],
    }

    yumrepo { $xcat::params::xcatdep :
        descr => $xcat::params::xcatdep_desc,
        baseurl => $xcat::params::xcatdep_mirror,
        enabled => 1,
	gpgcheck => 1,
	gpgkey => $xcat::params::xcatdep_key,
        require => Class["xcat::params"],
    }
}
