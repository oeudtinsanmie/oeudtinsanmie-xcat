# This has to be a separate type to enable collecting
Puppet::Type.newtype(:xcat_passwd_tbl) do
  @doc = 'password - a table definition in the xCAT database.'
  
  ensurable
  
  newparam(:key, :namevar=>true) do
    desc 'the type of component this user/pw is for. Valid values: blade (management module), ipmi (BMC), system (nodes), omapi (DHCP), hmc, ivm, cec, frame, switch.'

    def should_to_s(newvalue)
      newvalue.inspect
    end
    
    def is_to_s(currentvalue)
      currentvalue.inspect
    end
    
  end
  
  newproperty(:username) do
    desc 'The default userid for this type of component'
  end
  
  newproperty(:password) do
    desc 'The default password for this type of component'
  end
  
  newproperty(:cryptmethod) do
    desc 'Indicates the method that was used to encrypt the password attribute.'
  end
  
  newproperty(:authdomain) do
    desc 'The domain in which this entry has meaning, e.g. specifying different domain administrators per active directory domain'
  end
  
  newproperty(:comments) do
    desc 'Any user-written notes'
  end
  
  newproperty(:disable) do
    desc 'comment out this row'
    
    newvalues(:yes, :no)
    defaultto(:no)
  end
end
