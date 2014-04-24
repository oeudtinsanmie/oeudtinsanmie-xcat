class xcat::yuminstall {
    Package { 
        ensure => "latest",
        provider => "yum",
        require => Class["vclmgmt::installfrom"],
    }

    include $xcat::params

    package { $xcat::params::pkg_list : }

    package { $xcat::params::pkg_exclude :
        ensure => "absent",
    }
}
