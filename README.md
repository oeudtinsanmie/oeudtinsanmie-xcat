XCAT Puppet Module
==================
This module installs and configures the Extreme Cloud Administration Toolkit.  Including the xcat class will add the required repositories and install xcat and its dependencies.  

    include xcat

There are also custom types and providers for several XCAT objects, managed through the lsdef, mkdef, rmdef and chdef commands in XCAT.  See [xcat man pages](http://xcat.sourceforge.net/man5/xcatdb.5.html#object_definitions) for documentation on XCAT object definitions and their use.  The following XCAT objects are implemented so far:

- xcat_boottarget
- xcat_firmware
- xcat_group
- xcat_network
- xcat_node
- xcat_osdistro
- xcat_osdistroupdate
- xcat_osimage
- xcat_route

Attributes of the XCAT site table can also be configured using the xcat_site_attribute type and provider.

    xcat_site_attribute { "master" :
        sitename => 'clustersite',
        value => $fqdn,
    }
    
    xcat_site_attribute { "dhcpinterfaces" :
        sitename => 'clustersite',
        value => [ 'eth0.1004', 'eth0.1107', 'eth1' ],
    }
    
Base images can be installed using the xcat::image class, which uses the xcat copycds command via the xcat_copycds type and provider.  Images may be added by providing a url to a .iso file to be downloaded via wget (using the [maestrodev](https://forge.puppetlabs.com/maestrodev)/[wget](https://forge.puppetlabs.com/maestrodev/wget) module).  Alternatively, you may leave the url parameter out of your definition, or specify it as undef to load from .iso files that are part of the file system, however they were added previously or through other parts of your Puppet manifest.

    xcat::image{ "from_my_file" :
    	url		   => undef,
    	filepath => '/cds/my.iso',
    	distro   => 'Fedora12',
    	arch     => 'x86_64',
    }
    
    xcat::image { "centos6.5" :
      url => "http://ftp.linux.ncsu.edu/pub/CentOS/6.5/isos/x86_64/CentOS-6.5-x86_64-bin-DVD1.iso",
    	filepath => "/cds/CentOS-6.5-x86_64-bin-DVD1.iso",
    	arch => "x86_64",
    	distro => "centos6.5",
    }

