# This has to be a separate type to enable collecting
Puppet::Type.newtype(:route) do
  @doc = 'a logical object definition in the xCAT database.'

  newparam(:imagename, :namevar=>true) do
    desc 'The name of this xCAT OS image definition.'
  end
  
  newproperty(:usercomment) do 
    desc 'Any user-written notes.'
  end

  newproperty(:addkcmdline) do
    desc 'User specified arguments to be passed to the kernel. The user arguments are appended to xCAT.s default kernel arguments. This attribute is ignored if linuximage.boottarget is set.'
  end

  newproperty(:boottarget) do
    desc 'The name of the boottarget definition. When this attribute is set, xCAT will use the kernel, initrd and kernel params defined in the boottarget definition instead of the default.'
  end

  newproperty(:bosinst_data) do
    desc 'The name of a NIM bosinst_data resource.'
  end
  
  newproperty(:cfmdir) do
    desc 'CFM directory name for PCM. Set to /install/osimages/<osimage name>/cfmdir by PCM.'
  end
  
  newproperty(:configdump) do
    desc 'Specifies the type of system dump to be collected. The values are selective, full, and none. The default is selective.'
    newvalues(:selective, :full, :none)
    defaultto :selective
  end

  newproperty(:crashkernelsize) do
    desc 'the size that assigned to the kdump kernel. If the kernel size is not set, 256M will be the default value.'
    defaultto "256M"
  end
  
  newproperty(:description) do
    desc 'OS Image Description'
  end
  
  newproperty(:driverupdatesrc) do
    desc 'The source of the drivers which need to be loaded during the boot. Two types of driver update source are supported: Driver update disk and Driver rpm package. The value for this attribute should be comma separated sources. Each source should be the format tab:full_path_of_srouce_file. The tab keyword can be: dud (for Driver update disk) and rpm (for driver rpm). If missing the tab, the rpm format is the default. e.g. dud:/install/dud/dd.img,rpm:/install/rpm/d.rpm'
  end
  
  newproperty(:dump) do
    desc 'The NFS directory to hold the Linux kernel dump file (vmcore) when the node with this image crashes, its format is "nfs://<nfs_server_ip>/<kdump_path>". If you want to use the node\'s "xcatmaster" (its SN or MN), <nfs_server_ip> can be left blank. For example, "nfs:///<kdump_path>" means the NFS directory to hold the kernel dump file is on the node\'s SN, or MN if there\'s no SN.
    
    or
    
    The name of the NIM dump resource.'
  end
  
  newproperty(:exlist) do
    desc 'The fully qualified name of the file that stores the file names and directory names that will be excluded from the image during packimage command. It is used for diskless image only.'
  end
  
  newproperty(:fb_script) do
    desc 'The name of a NIM fb_script resource.'
  end
  
  newproperty(:groups, :array_matching => :all) do
    desc '(puppet uses an array for this) A comma-delimited list of image groups of which this image is a member. Image groups can be used in the litefile and litetree table instead of a single image name. Group names are arbitrary.'
    def insync?(is)
      # The current value may be nil and we don't
      # want to call sort on it so make sure we have arrays 
      # (@ref https://ask.puppetlabs.com/question/2910/puppet-types-with-array-property/)
      if is.is_a?(Array) and @should.is_a?(Array)
        is.sort == @should.sort
      else
        is == @should
      end
    end
  end
  
  newproperty(:home) do
    desc 'The name of the NIM home resource.'
  end
  
  newproperty(:image_data) do
    desc 'The name of a NIM image_data resource.'
  end
  
  newproperty(:imagetype) do
    desc 'The type of operating system image this definition represents (linux,AIX).'
  end
  
  newproperty(:installp_bundle, :array_matching => :all) do
    desc '(puppet uses an array for this) One or more comma separated NIM installp_bundle resources.'
    def insync?(is)
      # The current value may be nil and we don't
      # want to call sort on it so make sure we have arrays 
      # (@ref https://ask.puppetlabs.com/question/2910/puppet-types-with-array-property/)
      if is.is_a?(Array) and @should.is_a?(Array)
        is.sort == @should.sort
      else
        is == @should
      end
    end
  end
  
  newproperty(:installto) do
    desc 'The disk and partition that the Windows will be deployed to. The valid format is <disk>:<partition>. If not set, default value is 0:1 for bios boot mode(legacy) and 0:3 for uefi boot mode; If setting to 1, it means 1:1 for bios boot and 1:3 for uefi boot'
  end
  
  newproperty(:isdeletable) do
    desc 'A flag to indicate whether this image profile can be deleted. This attribute is only used by PCM.'
  end
  
  newproperty(:kerneldir) do
    desc 'The directory name where the 3rd-party kernel is stored. It is used for diskless image only.'
  end
  
  newproperty(:kernelver) do
    desc 'The version of linux kernel used in the linux image. If the kernel version is not set, the default kernel in rootimgdir will be used'
  end
  
  newproperty(:kitcomponents, :array_matching => :all) do
    desc '(puppet uses an array for this) List of Kit Component IDs assigned to this OS Image definition.'
    def insync?(is)
      # The current value may be nil and we don't
      # want to call sort on it so make sure we have arrays 
      # (@ref https://ask.puppetlabs.com/question/2910/puppet-types-with-array-property/)
      if is.is_a?(Array) and @should.is_a?(Array)
        is.sort == @should.sort
      else
        is == @should
      end
    end
  end
  
  newproperty(:krpmver) do
    desc 'The rpm version of kernel packages (for SLES only). If it is not set, the default rpm version of kernel packages will be used.'
  end
  
  newproperty(:lpp_source) do
    desc 'The name of the NIM lpp_source resource.'
  end
  
  newproperty(:mksysb) do
    desc 'The name of a NIM mksysb resource.'
  end
  
  newproperty(:netdrivers, :array_matching => :all) do
    desc '(puppet uses an array for this) The ethernet device drivers of the nodes which will use this linux image, at least the device driver for the nodes\' installnic should be included'
    def insync?(is)
      # The current value may be nil and we don't
      # want to call sort on it so make sure we have arrays 
      # (@ref https://ask.puppetlabs.com/question/2910/puppet-types-with-array-property/)
      if is.is_a?(Array) and @should.is_a?(Array)
        is.sort == @should.sort
      else
        is == @should
      end
    end
  end
  
  newproperty(:nimmethod) do
    desc 'The NIM install method to use, (ex. rte, mksysb).'
  end
  
  newproperty(:nimtype) do
    desc 'The NIM client type- standalone, diskless, or dataless.'
    newvalues(:standalone, :diskless, :dataless)
  end
  
  newproperty(:nodebootif) do
    desc 'The network interface the stateless/statelite node will boot over (e.g. eth0)'
  end
  
  newproperty(:osarch) do
    desc 'The hardware architecture of this node. Valid values: x86_64, ppc64, x86, ia64.'
    newvalues(:x86_64, :ppc64, :x86, :ia64)
  end
  
  newproperty(:osdistroname) do
    desc 'The name of the OS distro definition. This attribute can be used to specify which OS distro to use, instead of using the osname,osvers,and osarch attributes.'
  end
  
  newproperty(:osname) do
    desc 'Operating system name- AIX or Linux.'
    newvalues(:AIX, :Linux)
  end
  
  newproperty(:osupdatename, :array_matching => :all) do
    desc '(puppet uses an array for this) A comma-separated list of OS distro updates to apply to this osimage.'
    def insync?(is)
      # The current value may be nil and we don't
      # want to call sort on it so make sure we have arrays 
      # (@ref https://ask.puppetlabs.com/question/2910/puppet-types-with-array-property/)
      if is.is_a?(Array) and @should.is_a?(Array)
        is.sort == @should.sort
      else
        is == @should
      end
    end
  end
  
  newproperty(:osvers) do
    desc 'The Linux operating system deployed on this node. Valid values: rhels*,rhelc*, rhas*,centos*,SL*, fedora*, sles* (where * is the version #).'
  end
  
  newproperty(:otherifce, :array_matching => :all) do
    desc '(puppet uses an array for this) Other network interfaces (e.g. eth1) in the image that should be configured via DHCP'
    def insync?(is)
      # The current value may be nil and we don't
      # want to call sort on it so make sure we have arrays 
      # (@ref https://ask.puppetlabs.com/question/2910/puppet-types-with-array-property/)
      if is.is_a?(Array) and @should.is_a?(Array)
        is.sort == @should.sort
      else
        is == @should
      end
    end
  end
  
  newproperty(:otherpkgdir) do
    desc 'The base directory where the non-distro packages are stored.'
  end
  
  newproperty(:otherpkglist) do
    desc 'The fully qualified name of the file that stores non-distro package lists that will be included in the image.'
  end
  
  newproperty(:otherpkgs, :array_matching => :all) do
    desc '(puppet uses an array for this) One or more comma separated installp or rpm packages. The rpm packages must have a prefix of \'R:\', (ex. R:foo.rpm)'
    def insync?(is)
      # The current value may be nil and we don't
      # want to call sort on it so make sure we have arrays 
      # (@ref https://ask.puppetlabs.com/question/2910/puppet-types-with-array-property/)
      if is.is_a?(Array) and @should.is_a?(Array)
        is.sort == @should.sort
      else
        is == @should
      end
    end
  end
  
  newproperty(:paging) do
    desc 'The name of the NIM paging resource.'
  end
  
  newproperty(:partitionfile) do
    desc 'The path of the configuration file which is used to part the disk for the node. For stateful: two types of value can be set for this attribute. One is "<partition file absolute path>", the content of the partition file must use the corresponding format with the OS type. The other one is "s:<partition file absolute path>", the content of the partition file should be a shell script which must write the partition definition into /tmp/partitionfile on the node. For statelite: the valid value is <partition file absolute path>, refer to the statelite doc for the xCAT defined format of the configuration file.
    
    or
    
    The path of partition configuration file. Since the partition configuration for bios boot mode and uefi boot mode are different, this configuration file should include two parts if customer wants to support both bios and uefi mode. If customer just wants to support one of the modes, specify one of them anyway. Example of partition configuration file: [BIOS]xxxxxxx[UEFI]yyyyyyy. To simplify the setting, you also can set installto in partitionfile with section likes [INSTALLTO]0:1'
  end
  
  newproperty(:permission) do
    desc 'The mount permission of /.statelite directory is used, its default value is 755'
  end
  
  newproperty(:pkgdir) do
    desc 'The name of the directory where the distro packages are stored. It could be set multiple paths.The multiple paths must be seperated by ",". The first path in the value of osimage.pkgdir must be the OS base pkg dir path, such as pkgdir=/install/rhels6.2/x86_64,/install/updates . In the os base pkg path, there are default repository data. And in the other pkg path(s), the users should make sure there are repository data. If not, use "createrepo" command to create them.'
  end
  
  newproperty(:pkglist) do
    desc 'The fully qualified name of the file that stores the distro packages list that will be included in the image. Make sure that if the pkgs in the pkglist have dependency pkgs, the dependency pkgs should be found in one of the pkgdir'
  end
  
  newproperty(:postbootscripts, :array_matching => :all) do
    desc '(puppet uses an array for this) Comma separated list of scripts that should be run on this after diskfull installation or diskless boot. On AIX these scripts are run during the processing of /etc/inittab. On Linux they are run at the init.d time. xCAT automatically adds the scripts in the xcatdefaults.postbootscripts attribute to run first in the list. See the site table runbootscripts attribute.'
  end
  
  newproperty(:postinstall) do
    desc 'The fully qualified name of the script file that will be run at the end of the genimage command. It is used for diskless image only.'
  end
  
  newproperty(:postscripts, :array_matching => :all) do
    desc '(puppet uses an array for this) Comma separated list of scripts that should be run on this image after diskfull installation or diskless boot. For installation of RedHat, CentOS, Fedora, the scripts will be run before the reboot. For installation of SLES, the scripts will be run after the reboot but before the init.d process. For diskless deployment, the scripts will be run at the init.d time, and xCAT will automatically add the list of scripts from the postbootscripts attribute to run after postscripts list. For installation of AIX, the scripts will run after the reboot and acts the same as the postbootscripts attribute. For AIX, use the postbootscripts attribute. See the site table runbootscripts attribute. Support will be added in the future for the postscripts attribute to run the scripts before the reboot in AIX.'
  end
  
  newproperty(:profile) do
    desc 'The node usage category. For example compute, service.'
  end
  
  newproperty(:provmethod) do
    desc 'The provisioning method for node deployment. The valid values are install, netboot,statelite,boottarget,dualboot,sysclone. If boottarget is set, you must set linuximage.boottarget to the name of the boottarget definition. It is not used by AIX.'
    newvalues(:install, :netboot, :statelite, :boottarget, :dualboot, :sysclone)
  end
  
  newproperty(:resolv_conf) do
    desc 'The name of the NIM resolv_conf resource.'
  end
  
  newproperty(:root) do
    desc 'The name of the NIM root resource.'
  end
  
  newproperty(:rootfstype) do
    desc 'The filesystem type for the rootfs is used when the provmethod is statelite. The valid values are nfs or ramdisk. The default value is nfs'
    newvalues(:nfs, :ramdisk)
    defaultto :nfs
  end
  
  newproperty(:rootimgdir) do
    desc 'The directory name where the image is stored. It is used for diskless image only.'
  end
  
  newproperty(:script) do
    desc 'The name of a NIM script resource.'
  end
  
  newproperty(:serverrole) do
    desc 'The role of the server created by this osimage. Default roles: mgtnode, servicenode, compute, login, storage, utility.'
  end
  
  newproperty(:shared_home) do
    desc 'The name of the NIM shared_home resource.'
  end
  
  newproperty(:shared_root) do
    desc 'A shared_root resource represents a directory that can be used as a / (root) directory by one or more diskless clients.'
  end
  
  newproperty(:spot) do
    desc 'The name of the NIM SPOT resource.'
  end
  
  newproperty(:synclists, :array_matching => :all) do
    desc '(puppet uses an array for this) The fully qualified name of a file containing a list of files to synchronize on the nodes. Can be a comma separated list of multiple synclist files. The synclist generated by PCM named /install/osimages/<imagename>/synclist.cfm is reserved for use only by PCM and should not be edited by the admin.'
    def insync?(is)
      # The current value may be nil and we don't
      # want to call sort on it so make sure we have arrays 
      # (@ref https://ask.puppetlabs.com/question/2910/puppet-types-with-array-property/)
      if is.is_a?(Array) and @should.is_a?(Array)
        is.sort == @should.sort
      else
        is == @should
      end
    end
  end
  
  newproperty(:template) do
    desc 'The fully qualified name of the template file that is used to create the kick start file for diskful installation.
    
    or
    
    The fully qualified name of the template file that is used to create the windows unattend.xml file for diskful installation.'
  end
  
  newproperty(:tmp) do
    desc 'The name of the NIM tmp resource.'
  end
  
  newproperty(:winpepath) do
    desc 'The path of winpe which will be used to boot this image. If the real path is /tftpboot/winboot/winpe1/, the value for winpepath should be set to winboot/winpe1'
  end
end
