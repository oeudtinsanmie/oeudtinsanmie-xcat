include stdlib

# Class: xcat
#
# Declares required repositories and installs required packages for xCAT
# Removes duplicate packages that may be installed by default, but which interfere with xCAT
#
class xcat(
  $mgmt = undef,
  $images = undef,
  $templates = undef,
  $scripts = undef,
) inherits xcat::params {
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
  
  Yumrepo <| tag == 'xcatrepo' |> -> Package <| tag == 'xcatpkg' |>  -> Service <| tag == "xcat-service" |>
  
  Package <| tag == 'xcatpkg' |> -> Xcat::Template   <| |>
  Package <| tag == 'xcatpkg' |> -> Xcat::Image      <| |>
  Package <| tag == 'xcatpkg' |> -> Xcat_boottarget  <| |>
  Package <| tag == 'xcatpkg' |> -> Xcat_copycds     <| |>
  Package <| tag == 'xcatpkg' |> -> Xcat_firmware    <| |>
  Package <| tag == 'xcatpkg' |> -> Xcat_group       <| |>
  Package <| tag == 'xcatpkg' |> -> Xcat_osdistro    <| |>
  Package <| tag == 'xcatpkg' |> -> Xcat_osdistroupdate <| |>
  Package <| tag == 'xcatpkg' |> -> Xcat_osimage     <| |>
  Package <| tag == 'xcatpkg' |> -> Xcat_passwd_tbl  <| |>
  Package <| tag == 'xcatpkg' |> -> Xcat_route       <| |>
  Package <| tag == 'xcatpkg' |> -> Xcat_network     <| |> -> Xcat_node<| |>
  Package <| tag == 'xcatpkg' |> -> Xcat_site_attribute <| |> ~> Service['xcatd']
  Xcat_network <| ensure == absent |> -> Xcat_network <| ensure != absent |>
    
  ############## Mgmt Node #####################
  if $mgmt != undef {
    ensure_resource(xcat::mgmt, $mgmt)
  }

  ############## Images #####################
  if $images != undef {
    create_resources(xcat::image, $images)
  }
  
  ############## Templates ###################
  if $templates != undef {
    create_resources(xcat::template, $templates)
  }
  
  ############## Pre/Post Scripts ############
  if $scripts != undef {
    create_resources(xcat::script, scripts)
  }
}
