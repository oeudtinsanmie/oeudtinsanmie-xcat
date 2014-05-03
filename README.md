XCAT Puppet Module
==================
This module installs and configures the Extreme Cloud Administration Toolkit.  Including the xcat class will add the required repositories and install xcat and its dependencies.  

  include xcat

There are also custom types and providers for several XCAT objects, managed through the lsdef, mkdef, rmdef and chdef commands in XCAT.  See [xcat man pages](http://xcat.sourceforge.net/man5/xcatdb.5.html#object_definitions) for documentation on XCAT object definitions and their use.  The following XCAT objects are implemented so far:

- xcat_boottarget
- xcat_copycds
- xcat_firmware
- xcat_group
- xcat_network
- xcat_node
- xcat_osdistro
- xcat_osdistroupdate
- xcat_osimage
- xcat_route

