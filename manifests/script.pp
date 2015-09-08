include stdlib

define xcat::script(
  $filename = undef,
  $fileparams,
  $xcatroot = '/opt/xcat',
) {
  if $filename == undef {
    $myname = $name
  } else {
    $myname = $filepath
  }
  $filepath = xcat_script($xcatroot, $myname)
  
  ensure_resource(file, $myname, merge($fileparams), { path => $filepath })
}