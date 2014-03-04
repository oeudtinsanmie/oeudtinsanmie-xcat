# This has to be a separate type to enable collecting
Puppet::Type.newtype(:xcat_osdistroupdate) do
  @doc = 'a logical object definition in the xCAT database.'

  ensurable
  
  newparam(:osupdatename, :namevar=>true) do
    desc 'Name of OS update. (e.g. rhn-update1)'
  end

  newparam(:dirpath) do
    desc 'Path to where OS distro update is stored. (e.g. /install/osdistroupdates/rhels6.2-x86_64-20120716-update)'
  end
  
  newproperty(:downloadtime) do 
    desc 'The timestamp when OS distro update was downloaded..'
  end

  newproperty(:osdistroname) do
    desc 'The OS distro name to update. (e.g. rhels)'
  end

  newproperty(:usercomment) do
    desc 'Any user-written notes.'
  end

end
