# Class: xcat::image
#
# This class creates an xcat_copycds resource with the given filepath, distro and architecture
# If a url is provided, this class fetches an iso from the designated location with wget to the filepath before copycds
#
# Parameters:
# [*ensure*] 
#   - Passthrough for ensurable objects in this class
#     Defaults to present
# [*url*] 
#   - If defined, the url from which to fetch isos via wget
#     Defaults to undef
# [*filepath*]
#   - The location for the isos xcat_copycds with use
# [*distro*]
#   - Distribution of this iso
# [*arch*]
#   - Architecture this iso targets
define xcat::image(
  $ensure  = present,
  $url     = undef,
  $filepath,
  $distro,
  $arch,
) {
  if $url != undef {
    file { $filepath:
      ensure => directory,
      links => follow,
    } ->
    wget::fetch{ $url :
      destination  => $filepath,
      timeout      => 0,
      verbose      => false,
    } ->
    xcat_copycds { "${distro}-${arch}" :
      ensure => $ensure,
      distro => $distro,
      file    => $filepath,
      arch    => $arch,
    }
  } 
  else {
    xcat_copycds { "${distro}-${arch}" :
      ensure  => $ensure,
      distro  => $distro,
      file    => $filepath,
      arch    => $arch,
    }
  }
}
