# This has to be a separate type to enable collecting
Puppet::Type.newtype(:xcat_firmware) do
  @doc = 'Maps node to firmware values to be used for setup at node discovery or later'

  ensurable
  
  newparam(:name, :namevar=>true) do
    desc 'node      The node id.'
  end

  newparam(:cfgfile) do
    desc 'The file to use.'
  end
  
  newproperty(:comments) do 
    desc 'Any user-written notes.'
  end

  newproperty(:disable) do
    desc "Set to 'yes' or '1' to comment out this row."
  end

end
