# This has to be a separate type to enable collecting
Puppet::Type.newtype(:xcat_osdistro) do
  @doc = 'a logical object definition in the xCAT database.'

  newparam(:osdistroname, :namevar=>true) do
    desc 'Unique name (e.g. rhels6.2-x86_64)'
  end

  newparam(:arch) do
    desc 'The OS distro arch (e.g. x86_64)'
  end
  
  newproperty(:basename) do 
    desc 'The OS base name (e.g. rhels)'
  end

  newproperty(:dirpaths) do
    desc 'Directory paths where OS distro is store. There could be multiple paths if OS distro has more than one ISO image. (e.g. /install/rhels6.2/x86_64,...)'
  end

  newproperty(:majorversion) do
    desc 'The OS distro major version.(e.g. 6)'
  end

  newproperty(:minorversion) do
    desc 'The OS distro minor version.(e.g. 6)'
  end

  newproperty(:type) do
    desc 'Linux or AIX'
  end

end
