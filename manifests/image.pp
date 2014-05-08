include xcat

define xcat::image(
	$ensure		= present,
	$url		= undef,
	$filepath,
	$distro,
	$arch,
) {
	if $url != undef {
		wget::fetch{ $url :
			destination => $filepath,
			timeout => 0,
			verbose => false,
		} ->
		xcat_copycds { "${distro}-${arch}" :
			ensure  => $ensure,
			distro  => $distro,
			file 	=> $filepath,
			arch 	=> $arch,
		}
	} 
	else {
		xcat_copycds { "${distro}-${arch}" :
                        ensure 	=> $ensure,
			distro  => $distro,
			file 	=> $filepath,
			arch 	=> $arch,
		}
	}
}
