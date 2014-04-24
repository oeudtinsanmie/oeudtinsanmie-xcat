class xcat::params {

    $xcatcore = 'xcat-2-core'
    $xcatdep  = 'xcat-dep'
    $xcatcore_desc = 'xCat 2 Core packages'
    $xcatdep_desc  = 'xCat 2 Core dependencies'

#    case $operatingsystem {
#        /(RedHat|CentOS|Fedora)/: {
            $xcatcore_mirror = 'http://sourceforge.net/projects/xcat/files/yum/2.8/xcat-core'
            $xcatdep_mirror  = "http://sourceforge.net/projects/xcat/files/yum/xcat-dep/rh${lsbmajdistrelease}/${architecture}"
            $key = '/repodata/repomd.xml.key'
            $xcatcore_key = "${xcatcore_mirror}${key}"
            $xcatdep_key = "${xcatdep_mirror}${key}"

            $pkg_list = [ "tftp-server.${architecture}", "xCAT", "OpenIPMI-devel" ]

            $pkg_exclude = [ "atftp-xcat.${architecture}" ]

}
