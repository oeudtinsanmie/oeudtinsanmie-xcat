# This has to be a separate type to enable collecting
Puppet::Type.newtype(:xcat_site_attribute) do
  @doc = 'Manage the xcat site table.'

  newparam(:name, :namevar=>true) do
    desc 'Attribute name'
  end
  
  newproperty(:sitename) do
    desc 'Name of the xcat site object'
  end
  
  # This is a way of managing array properties stored as strings and whose order does not matter
  # And so users can specify a one-entry list or a string, with the same result
  newproperty(:value, :array_matching => :all) do
    desc 'Array of values for this XCat Site Attribute'
    def insync?(is)
      # The current value may be nil and we don't
      # want to call sort on it so make sure we have arrays 
      # (@ref https://ask.puppetlabs.com/question/2910/puppet-types-with-array-property/)
      if is.is_a?(Array) and @should.is_a?(Array)
        is.sort == @should.sort
      elsif @should.is_a?(Array) and @should.length == 1
        is == @should[0]
      else
        is == @should
      end
    end

    def should_to_s(newvalue)
      newvalue.inspect
    end

    def is_to_s(currentvalue)
      currentvalue.inspect
    end

  end

end
