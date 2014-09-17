include xcat

define xcat::template(
  $os,
  $xcatroot = '/opt/xcat',
  $zerombr = true,
  $clearpart = [ 'all', 'initlabel', ],
  $cmdline = false,
  $partitions, # <-- add a sane list here = [],
  $keyboard = 'us',
  $lang = 'en_US',
  $bootloaderopts = [],
  $installupgrade = 'install',
  $installmode = '',
  $firewall = [ 'disable' ],
  $authconfig = [ 'usershadow', 'enabledmd5', ],
  $selinux = [ 'disabled', ],
  $mouse = '',
  $skipx = true,
  $resolvedeps = false,
  $pkgs, # <-- add sane list here = [],
  $otheropts = [],
  $prescripts = undef,
  $postscripts = undef,
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
