# This has to be a separate type to enable collecting
Puppet::Type.newtype(:group) do
  @doc = 'group - a logical object definition in the xCAT database.'

  newparam(:groupname, :namevar=>true) do
    desc '(nodegroup.groupname) Name of the group.'
  end

  newparam(:addkmdline) do
    desc '(bootparams.addkcmdline) User specified one or more parameters to be passed to the kernel'
  end
  
  newproperty(:usercomment) do 
    desc 'Any user-written notes.'
  end

  newproperty(:auth) do
    desc '(nodetype.arch) The hardware architecture of this node. Valid values: x86_64, ppc64, x86, ia64.'
    newvalues(:x86_64, :ppc64, :x86, :ia64)
  end

  newproperty(:authdomain) do
    desc '(domain.authdomain) If a node should participate in an AD domain or Kerberos realm distinct from domain indicated in site, this field can be used to specify that'
  end

  newproperty(:bmc) do
    desc '(ipmi.bmc) The hostname of the BMC adapater.'
  end

  newproperty(:bmcpassword) do
    desc '(ipmi.password) The BMC password. If not specified, the key=ipmi row in the passwd table is used as the default.'
  end

  newproperty(:bmcport) do
    desc '(ipmi.bmcport) In systems with selectable shared/dedicated ethernet ports, this parameter can be used to specify the preferred port. 0 means use the shared port, 1 means dedicated, blank is to not assign'
  end

  newproperty(:bmcusername) do
    desc '(ipmi.username) The BMC userid. If not specified, the key=ipmi row in the passwd table is used as the default.'
  end

  newproperty(:cfgmgr) do
    desc '(cfgmgt.cfgmgr) The name of the configuration manager service. Currently \'chef\' and \'puppet\' are supported services.'
  end

  newproperty(:cfgmgtroles) do
    desc '(cfgmgt.roles) The roles associated with this node as recognized by the cfgmgr for the software that is to be installed and configured. These role names map to chef recipes or puppet manifest classes that should be used for this node. For example, chef OpenStack cookbooks have roles such as mysql-master,keystone, glance, nova-controller, nova-conductor, cinder-all.'
  end

  newproperty(:cfgserver) do
    desc '(cfgmgt.cfgserver) The xCAT node name of the chef server or puppet master'
  end

  newproperty(:chain) do
    desc '(chain.chain) A comma-delimited chain of actions to be performed automatically when this node is discovered. ("Discovered" means a node booted, but xCAT and DHCP did not recognize the MAC of this node. In this situation, xCAT initiates the discovery process, the last step of which is to run the operations listed in this chain attribute, one by one.) Valid values: boot or reboot, install or netboot, runcmd=<cmd>, runimage=<URL>, shell, standby. (Default - same as no chain - it will do only the discovery.). Example, for BMC machines use: runcmd=bmcsetup,shell.'
  end

  newproperty(:chassis) do
    desc '(nodepos.chassis) The BladeCenter chassis the blade is in.'
  end

  newproperty(:cmdmapping) do
    desc '(nodehm.cmdmapping) The fully qualified name of the file that stores the mapping between PCM hardware management commands and xCAT/third-party hardware management commands for a particular type of hardware device. Only used by PCM.'
  end

  newproperty(:cons) do
    desc '(nodehm.cons) The console method. If nodehm.serialport is set, this will default to the nodehm.mgt setting, otherwise it defaults to unused. Valid values: cyclades, mrv, or the values valid for the mgt attribute.'
  end

  newproperty(:conserver) do
    desc '(nodehm.conserver) The hostname of the machine where the conserver daemon is running. If not set, the default is the xCAT management node.'
  end

  newproperty(:cpucount) do
    desc '(hwinv.cpucount) The number of cpus for the node.'
  end

  newproperty(:cputype) do
    desc '(hwinv.cputype) The cpu model name for the node.'
  end

  newproperty(:dhcpinterfaes) do
    desc '(servicenode.dhcpinterfaces) The network interfaces DHCP server should listen on for the target node. This attribute can be used for management node and service nodes. If defined, it will override the values defined in site.dhcpinterfaces. This is a comma separated list of device names. !remote! indicates a non-local network for relay DHCP. For example: !remote!,eth0,eth1'
  end

  newproperty(:disksize) do
    desc '(hwinv.disksize) The size of the disks for the node.'
  end

  newproperty(:displayname) do
    desc '(mpa.displayname) Alternative name for BladeCenter chassis. Only used by PCM.'
  end

  newproperty(:domainadminpassword) do
    desc '(domain.adminpassword) Allow a node specific indication of Administrative user password for the domain. Most will want to ignore this in favor of passwd table.'
  end

  newproperty(:domainadminuser) do
    desc '(domain.adminuser) Allow a node specific indication of Administrative user. Most will want to just use passwd table to indicate this once rather than by node.'
  end

  newproperty(:domaintype) do
    desc '(domain.type) Type, if any, of authentication domain to manipulate. The only recognized value at the moment is activedirectory.'
  end

  newproperty(:getmac) do
    desc '(nodehm.getmac) The method to use to get MAC address of the node with the getmac command. If not set, the mgt attribute will be used. Valid values: same as values for mgmt attribute.'
  end

  newproperty(:grouptype) do
    desc '(nodegroup.grouptype) The only current valid value is dynamic. We will be looking at having the object def commands working with static group definitions in the nodelist table.'
  end

  newproperty(:hcp) do
    desc '(ppc.hcp, zvm.hcp) The hardware control point for this node (HMC, IVM, Frame or CEC). Do not need to set for BPAs and FSPs.

or

The hardware control point for this node.'
  end

  newproperty(:height) do
    desc '(nodepos.height) The server height in U(s).'
  end

  newproperty(:hostcluster) do
    desc 'Specify to the underlying virtualization infrastructure a cluster membership for the hypervisor.'
  end

  newproperty(:hostinterface) do
    desc '(hypervisor.interface) The definition of interfaces for the hypervisor. The format is [networkname:interfacename:bootprotocol:IP:netmask:gateway] that split with | for each interface'
  end

  newproperty(:hostmanager) do
    desc '(hypervisor.mgr) The virtualization specific manager of this hypervisor when applicable'
  end

  newproperty(:hostnames) do
    desc '(hosts.hostnames) Hostname aliases added to /etc/hosts for this node. Comma or blank separated list.'
  end

  newproperty(:hosttype) do
    desc '(hypervisor.type) The plugin associated with hypervisor specific commands such as revacuate'
  end

  newproperty(:hwtype) do
    desc '(ppc.nodetype, zvm.nodetype, mp.nodetype, mic.nodetype) The hardware type of the node. Only can be one of fsp, bpa, cec, frame, ivm, hmc and lpar

or

The node type. Valid values: cec (Central Electronic Complex), lpar (logical partition), zvm (z/VM host operating system), and vm (virtual machine).

or

The hardware type for mp node. Valid values: mm,cmm, blade.

or

The hardware type of the mic node. Generally, it is mic.'
  end

  newproperty(:id) do
    desc '(ppc.id, mp.id) For LPARs: the LPAR numeric id; for CECs: the cage number; for Frames: the frame number.

or

The slot number of this blade in the BladeCenter chassis.'
  end

  newproperty(:initrd) do
    desc '(bootparams.initrd) The initial ramdisk image that network boot actions should use (could be a DOS floppy or hard drive image if using memdisk as kernel)'
  end

  newproperty(:installnic) do
    desc '(noderes.installnic) The network adapter on the node that will be used for OS deployment, the installnic can be set to the network adapter name or the mac address or the keyword "mac" which means that the network interface specified by the mac address in the mac table will be used. If not set, primarynic will be used.'
  end

  newproperty(:interface) do
    desc '(mac.interface) The adapter interface name that will be used to install and manage the node. E.g. eth0 (for linux) or en0 (for AIX).)'
  end

  newproperty(:ip) do
    desc '(hosts.ip) The IP address of the node. This is only used in makehosts. The rest of xCAT uses system name resolution to resolve node names to IP addresses.'
  end

  newproperty(:iscsipassword) do
    desc '(iscsi.passwd) The password for the iscsi server containing the boot device for this node.'
  end

  newproperty(:iscsiserver) do
    desc '(iscsi.server) The server containing the iscsi boot device for this node.'
  end

  newproperty(:iscsitarget) do
    desc '(iscsi.target) The iscsi disk used for the boot device for this node. Filled in by xCAT.'
  end

  newproperty(:iscsiuserid) do
    desc '(iscsi.userid) The userid of the iscsi server containing the boot device for this node.'
  end

  newproperty(:kcmdline) do
    desc '(bootparams.kcmdline) Arguments to be passed to the kernel'
  end

  newproperty(:kernel) do
    desc '(bootparams.kernel) The kernel that network boot actions should currently acquire and use. Note this could be a chained boot loader such as memdisk or a non-linux boot loader'
  end
end
