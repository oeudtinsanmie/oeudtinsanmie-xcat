# Class: xcat
#
# Declares required repositories and installs required packages for xCAT
# Removes duplicate packages that may be installed by default, but which interfere with xCAT
#
class xcat inherits xcat::params {
  create_resources(yumrepo, $xcat::params::repos, $xcat::params::defaultrepo)

  package { $xcat::params::pkg_list : 
    ensure => "latest",
    tag => 'xcatpkg',
  } ->
  package { $xcat::params::pkg_exclude :
    ensure => "absent",
    tag => 'xcatpkg',
  }
  
  Yumrepo <| tag == 'xcatrepo' |> -> Package <| tag == 'xcatpkg' |> 
}
