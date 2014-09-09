class Puppet::Type::Xcatobject < Puppet::Type
  
  def self.decl_unord_arrys 
    self.arrayproperties.each do | pname, pconf |
      newproperty(pname, :array_matching => :all) do
        desc pconf[:desc]
        
        def insync? (is)
          # The current value may be nil and we don't
          # want to call sort on it so make sure we have arrays 
          # (@ref https://ask.puppetlabs.com/question/2910/puppet-types-with-array-property/)
          if (is.is_a?(Array) and @should.is_a?(Array)) then
            is.sort == @should.sort
          # Also, since parent provider doesn't know which properties are array matching, check for single entry list
          elsif @should.is_a?(Array) and @should.length == 1
            is == @should[0]
          else
            is == @should
          end
        end
        
        # These just make it easier to see what is going on in notices and debug statements
        def should_to_s(newvalue)
          newvalue.inspect
        end
      
        def is_to_s(currentvalue)
          currentvalue.inspect
        end
        
        # set a default value, if requested
        if (pconf[:default]) then
          defaultto pconf[:default]
        end
        
        # validate that each value in array is one of the valid values
        if (pconf[:values]) then
          validate do |value|
            if (value == nil) then 
              return
            end
            value.each { |val|
              if !pconf[:values].include? val
                raise ArgumentError, "#{val} is not a valid group for images.  Please use one of [ #{pconf[:values].join(',')} ]"
              end
            }
          end
        end
      end
    end
  end

end
