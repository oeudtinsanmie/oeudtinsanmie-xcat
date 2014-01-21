# This has to be a separate type to enable collecting
Puppet::Type.newtype(:xcat_resource) do
  @doc = 'Manage the xcat site table.'

  newparam(:name, :namevar=>true) do
    desc 'XCat Resource name'
  end

  newparam(:type) do
    desc 'XCat Resource type: object or table'
    newvalues(:object, :table)
  end
  
  newproperty(:value, :array_matching => :all) do
    desc 'Array of values for this XCat Resource'
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

end