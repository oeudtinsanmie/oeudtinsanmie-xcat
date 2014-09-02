class Puppet::Provider::XCatObject < Puppet::Provider

  commands  :lsdef => '/opt/xcat/bin/lsdef',
            :mkdef => '/opt/xcat/bin/mkdef',
            :rmdef => '/opt/xcat/bin/rmdef',
            :chdef => '/opt/xcat/bin/chdef'
            
  def list_obj (xcat_type, obj_name = nil)
    cmd_list = ["-l", "-t", xcat_type]
    if (obj_name) 
      cmd_list += ["-o", obj_name]
    end
    
    begin
      output = lsdef(cmd_list)
    rescue Puppet::ExecutionFailure => e
      Puppet.debug "lsdef had an error -> #{e.inspect}"
      return {}
    end
    
    obj_strs = output.split("Object name: ")
    obj_strs.delete("")
    obj_strs
  end
  
  def make_hash(obj_str)
    hash_list = obj_str.split("\n")
    inst_name = hash_list.shift
    inst_hash = Hash.new
    inst_hash[:name]   = inst_name
    inst_hash[:ensure] = :present
    hash_list.each { |line|
      key, value = line.split("=")
      # Puppet.debug "#{key} == #{value}"
      inst_hash[key.lstrip] = value
      # Puppet.debug "#{key.lstrip} == #{inst_hash[key.lstrip]}"
    }
    # Puppet.debug pp inst_hash
    Puppet::Util::symbolizehash(inst_hash)
  end

  def doflush (xcat_type)
    if @property_flush
      cmd_list = ["-t", xcat_type, "-o", resource[:name]]
      if (@property_flush[:ensure] == :absent)
        # rmdef
        begin
          rmdef(cmd_list)
        rescue Puppet::ExecutionFailure => e
          raise Puppet::Error, "rmdef #{cmd_list} failed to run: #{e}"
        end
        @property_hash.clear
      else
        resource.to_hash.each { |key, value|
          if not [:name, :ensure, :provider, :loglevel, :before, :after].include?(key) 
            if value.is_a?(Array)
              value = value.join()
            end
            cmd_list += ["#{key}=#{value}"]
          end
        }
        if (@property_flush[:ensure] == :present)
          # mkdef
          begin
            mkdef(cmd_list)
          rescue Puppet::ExecutionFailure => e
            raise Puppet::Error, "mkdef #{cmd_list} failed to run: #{e}"
          end
        else
          # chdef
          begin
            chdef(cmd_list)
          rescue Puppet::ExecutionFailure => e
            raise Puppet::Error, "chdef #{cmd_list} failed to run: #{e}"
          end
        end
      end
      @property_flush = nil
    end
    # refresh @property_hash
    @property_hash = make_hash(list_obj(xcat_type, resource[:name])[0])
  end
end
