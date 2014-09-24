# Class: xcat::template
#
# This class defines related tmpl and pkglist files for an xcat template
# You can use the xcat_script function to configure your own pre and postscript files in the correct filepath using the File resource 
#
# Parameters:
# [*os*]
#   - OS for which to use this template
# [*xcatroot*] 
#   - Root folder of xCAT
#     Defaults to '/opt/xcat',
# [*zerombr*] 
#   - Zero the MBR during provisioning
#     Defaults to true
# [*clearpart*] 
#   - Clear partitions during provisioning according to these arguments.  If empty, clearpart line is not added to the kickstart template
#     Defaults to [ 'all', 'initlabel', ]
# [*cmdline*] 
#   - Add cmdline to kickstart template
#     Defaults to false
# [*partitions*]
#   - Array of partition definition lines to add to the kickstart template
#     May include part and raid lines, for example.  I won't document the partition syntax here.  Check out kickstart template documentation.  There are many good examples out there
# [*keyboard*] 
#   - Keyboard type
#     Defaults to 'us'
# [*lang*] 
#   - Language
#     Defaults to 'en_US'
# [*bootloaderopts*] 
#   - Options for bootloader
#     Defaults to [],
# [*installupgrade*] 
#   - Install or Upgrade
#     Defaults to 'install'
# [*installmode*] 
#   - Default install mode is graphical.  You can put text here to specify a text installer.
#     Defaults to '',
# [*firewall*] 
#   - Arguments for the firewall line of the kickstart template.  Skips if this array is empty.
#     Defaults to [ 'disable' ]
# [*authconfig*] 
#   - Arguments for the authconfig line of the kickstart template.  Skips if this array is empty. 
#     Defaults to [ 'usershadow', 'enabledmd5', ]
# [*selinux*] 
#   - Arguments for the selinux line of the kickstart template.  Skips if this array is empty.
#     Defaults to [ 'disabled', ]
# [*mouse*] 
#   - Mouse settings.  Skips if string is empty.
#     Defaults to ''
# [*skipx*] 
#   - Whether to skip installation of XWindows support.  Adds the skipx line to the kickstart template if true.
#     Defaults to true
# [*resolvedeps*] 
#   - Add --resolvedeps to the %packages line (Don't use this if it's been deprecated for the operating system version you are using)
#     Defaults to false
# [*pkgs*]
#   - Array of packages to install.  Gets put in the .pkglist file for this xcat template
# [*otheropts*] 
#   - Any other lines you wish to be added to the kickstart template.
#     Defaults to []
# [*prescripts*] 
#   - Array of prescripts to import into kickstart via xCAT.  You can use the xcat_script function to configure your own pre and postscript files in the correct filepath using the File resource 
#     Defaults to [ "pre.${os}", ]
# [*postscripts*] 
#   - Array of postscripts to import into kickstart via xCAT.  You can use the xcat_script function to configure your own pre and postscript files in the correct filepath using the File resource
#     Defaults to [ "post.${os}", ]
#
define xcat::template(
  $os,
  $xcatroot       = '/opt/xcat',
  $zerombr        = true,
  $clearpart      = [ 'all', 'initlabel', ],
  $cmdline        = false,
  $partitions,    # <-- add a sane list here = [],
  $keyboard       = 'us',
  $lang           = 'en_US',
  $bootloaderopts = [],
  $installupgrade = 'install',
  $installmode    = '',
  $firewall       = [ 'disable' ],
  $authconfig     = [ 'usershadow', 'enabledmd5', ],
  $selinux        = [ 'disabled', ],
  $mouse          = '',
  $skipx          = true,
  $resolvedeps    = false,
  $pkgs,          # <-- add sane list here = [],
  $otheropts      = [],
  $prescripts     = undef,
  $postscripts    = undef,
) {
  if $prescripts == undef {
    $pre = [ "pre.${os}", ]
  }
  else {
    $pre = $prescripts
  }
  if $postscripts == undef {
    $post = [ "post.${os}", ]
  }
  else {
    $post = $postscripts
  }
  
  file { "${name}.tmpl" :
    path => "${xcatroot}/share/xcat/install/${os}/${name}.tmpl",
    content => template('xcat/tmpl.erb'),
  }
  
  file { "${name}.pkglist" :
    path => "${xcatroot}/share/xcat/install/${os}/${name}.pkglist",
    content => template('xcat/pkglist.erb'),
  }
}
