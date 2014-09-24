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
  
  create_resources(service, $xcat::params::service_list, $xcat::params::servicedefault)
  
  Yumrepo <| tag == 'xcatrepo' |> -> Package <| tag == 'xcatpkg' |> 
  
  Class['xcat'] -> Xcat::Template   <| |>
  Class['xcat'] -> Xcat::Image      <| |>
  Class['xcat'] -> Xcat_boottarget  <| |>
  Class['xcat'] -> Xcat_copycds     <| |>
  Class['xcat'] -> Xcat_firmware    <| |>
  Class['xcat'] -> Xcat_group       <| |>
  Class['xcat'] -> Xcat_osdistro    <| |>
  Class['xcat'] -> Xcat_osdistroupdate <| |>
  Class['xcat'] -> Xcat_osimage     <| |>
  Class['xcat'] -> Xcat_passwd_tbl  <| |>
  Class['xcat'] -> Xcat_route       <| |>
  Class['xcat'] -> Xcat_network <| |> -> Xcat_node<| |>
  Class['xcat'] -> Xcat_site_attribute <| |> ~> Service['xcatd']
  Xcat_network <| ensure == absent |> -> Xcat_network <| ensure != absent |>
}
