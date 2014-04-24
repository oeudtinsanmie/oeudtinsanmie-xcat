Puppet::Type.newtype(:xcat_copycds) do

  ensurable

  newparam(:name, :namevar=>true) do

  end

  newparam(:distro) do
    desc 'The linux distro name and version that the ISO/DVD contains. Examples: rhels6.3, sles11.2, fedora9. Note the \'s\' in rhels6.3 which denotes the Server version of RHEL, which is typically used.'
  end

  newparam(:file) do
    desc 'The local location of the iso image to load.'
  end

  newproperty(:arch) do 
    desc 'The architecture of the linux distro on the ISO/DVD. Examples: x86, x86_64, ppc64, s390x.'
  end
  
end
