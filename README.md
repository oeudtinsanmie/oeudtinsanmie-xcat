XCAT Puppet Module
==================
This module installs and configures the Extreme Cloud Administration Toolkit.  Including the xcat class will add the required repositories and install xcat and its dependencies.  It will also define the chaining rules for the types and classes defined below.  

    include xcat

xCAT Objects 
------------
There are also custom types and providers for several XCAT objects, managed through the lsdef, mkdef, rmdef and chdef commands in XCAT.  See [xcat man pages](http://xcat.sourceforge.net/man5/xcatdb.5.html#object_definitions) for documentation on XCAT object definitions and their use.  The following XCAT objects are implemented so far:

- [xcat_boottarget](http://xcat.sourceforge.net/man7/boottarget.7.html)
- [xcat_firmware](http://xcat.sourceforge.net/man7/firmware.7.html)
- [xcat_group](http://xcat.sourceforge.net/man7/group.7.html)
- [xcat_network](http://xcat.sourceforge.net/man7/network.7.html)
- [xcat_node](http://xcat.sourceforge.net/man7/node.7.html)
- [xcat_osdistro](http://xcat.sourceforge.net/man7/osdistro.7.html)
- [xcat_osdistroupdate](http://xcat.sourceforge.net/man7/osdistroupdate.7.html)
- [xcat_osimage](http://xcat.sourceforge.net/man7/osimage.7.html)
- [xcat_route](http://xcat.sourceforge.net/man7/route.7.html)

xCAT Tables 
-----------
Infrastructure for types and providers for [xCAT tables](http://xcat.sourceforge.net/man5/xcatdb.5.html#tables), using tabdump and chtab, is also laid out.  Currently, only the passwd table has a type and provider

- [xcat_passwd_tbl](http://xcat.sourceforge.net/man5/passwd.5.html)

xCAT Site Table 
---------------
Attributes of the XCAT site table can also be configured using the xcat_site_attribute type and provider.

    xcat_site_attribute { "master" :
        sitename =>> 'clustersite',
        value =>> $fqdn,
    }
    
    xcat_site_attribute { "dhcpinterfaces" :
        sitename =>> 'clustersite',
        value =>> [ 'eth0.1004', 'eth0.1107', 'eth1' ],
    }
    
Xcat::Image 
------------
Base images can be installed using the xcat::image class, which uses the xcat copycds command via the xcat_copycds type and provider.  Images may be added by providing a url to a .iso file to be downloaded via wget (using the [maestrodev](https://forge.puppetlabs.com/maestrodev)/[wget](https://forge.puppetlabs.com/maestrodev/wget) module).  Alternatively, you may leave the url parameter out of your definition, or specify it as undef to load from .iso files that are part of the file system, however they were added previously or through other parts of your Puppet manifest.

    xcat::image{ "from_my_file" :
        url      =>> undef,
        filepath =>> '/cds/my.iso',
        distro   =>> 'Fedora12',
        arch     =>> 'x86_64',
    }
    
    xcat::image { "centos6.5" :
        url      =>> "http://ftp.linux.ncsu.edu/pub/CentOS/6.5/isos/x86_64/CentOS-6.5-x86_64-bin-DVD1.iso",
        filepath =>> "/cds/CentOS-6.5-x86_64-bin-DVD1.iso",
        arch     =>> "x86_64",
        distro   =>> "centos6.5",
    }

Xcat::Template 
---------------
This class creates the .tmpl and .pkglist files xcat uses to define a kickstart template.  Pre and post scripts can be defined for xCAT to import during kickstart generation.  These arguments are a very simple map to kickstart file parameters.  You can also add additional lines to the kickstart file by adding them to the string arry, otheropts.  Pre and post scritps are imported by xCAT during nodeset, and reside within xCAT's directory structure.  You can use the xcat_script function to place your File resources in the correct path to be used by xCAT as prescripts or postscripts. 

    xcat::template { 'centos65-myprofile': 
        os             => 'centos',                         # OS for which to use this template
        xcatroot       => '/opt/xcat',                      # Root folder of xCAT
        zerombr        => true,                             # Zero the MBR during provisioning
        clearpart      => [ 'all', 'initlabel', ],          # Clear partitions during provisioning according to these arguments.  
                                                            # If empty, clearpart line is not added to the kickstart template
        cmdline        => false,                            # Add cmdline to kickstart template
        partitions     => [                                 # Array of partition definition lines to add to the kickstart template
            'part swap --size 1024',
            'part / --size 1 --grow --fstype ext3',
        ],    
        keyboard       => 'us',                             # Keyboard type
        lang           => 'en_US',                          # Language
        bootloaderopts => [],                               # Options for bootloader
        installupgrade => 'install',                        # Install or Upgrade
        installmode    => '',                               # Default install mode is graphical.  You can put text here to specify a text installer.
        firewall       => [ 'disable' ],                    # Arguments for the firewall line of the kickstart template.  Skips if this array is empty.
        authconfig     => [ 'usershadow', 'enabledmd5', ],  # Arguments for the authconfig line of the kickstart template.  Skips if this array is empty. 
        selinux        => [ 'disabled', ],                  # Arguments for the selinux line of the kickstart template.  Skips if this array is empty.
        mouse          => '',                               # Mouse settings.  Skips if string is empty.
        skipx          => true,                             # Whether to skip installation of XWindows support.  Adds the skipx line to the kickstart template if true.
        resolvedeps    => false,                            # Add --resolvedeps to the %packages line 
                                                            # (Don't use this if it's been deprecated for the operating system version you are using)
        pkgs           => [                                 # Array of packages to install.  Gets put in the .pkglist file for this xcat template
            '@ Desktop',
            'autofs',
            'ksh',
            'tcsh',
            'ntp',
            'nfs-utils',
            'net-snmp',
            'openssh-server',
            'util-linux-ng',
        ],          
        otheropts      => [],                               # Any other lines you wish to be added to the kickstart template.
        prescripts     => [ 'pre.rh', ],                    # Array of prescripts to import into kickstart via xCAT.  If left undefined, it defaults to Defaults to [ "pre.${os}", ]
        postscripts    => [ 'post.rh', ],                   # Array of postscripts to import into kickstart via xCAT. If left undefined, it defaults to Defaults to [ "post.${os}", ]
    }

xcat_script Function 
--------------------
You can use the xcat_script function to configure your own pre and postscript files in the correct filepath using the File resource.  For example:

    file { 'pre.mine' :
        path   => "${xcat_script('pre.mine')}",
        source => "puppet:///modules/mymodule/pre.mine",
    }
    
    xcat::template { 'mytemplate' :
        os => 'ubuntu',
        partitions     => [ 
            'part swap --size 1024',
            'part / --size 1 --grow --fstype ext3',
        ], 
        pkgs           => [ 
            '@ Desktop',
        ],
        prescripts     => [ 'pre.ubuntu', 'pre.mine', ],
    }

