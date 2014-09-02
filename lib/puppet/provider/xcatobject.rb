class Puppet::Provider::Xcatobject < Puppet::Provider

  # Without initvars commands won't work.
  initvars
  commands  :lsdef => '/opt/xcat/bin/lsdef',
            :mkdef => '/opt/xcat/bin/mkdef',
            :rmdef => '/opt/xcat/bin/rmdef',
            :chdef => '/opt/xcat/bin/chdef'  
          
  def self.list_obj (xcat_type, obj_name = nil)
    Puppet.debug "Listing xcat objects of type #{xcat_type}"
    if(obj_name) then
      Puppet.debug "Looking for object #{obj_name}"
    end
    list_obj_strings(xcat_type, obj_name).collect { |objstr|
        make_hash(objstr)
    }
  end

  def self.list_obj_strings (xcat_type, obj_name = nil)
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
  
  def self.make_hash(obj_str)
    hash_list = obj_str.split("\n")
    inst_name = hash_list.shift
    inst_hash = Hash.new
    inst_hash[:name]   = inst_name
    inst_hash[:ensure] = :present
    hash_list.each { |line|
      key, value = line.split("=")
      # Puppet.debug "#{key} == #{value}"
      if (value.include? ",") then 
        inst_hash[key.lstrip] = value.split(",")
      else
        inst_hash[key.lstrip] = value
      end
      # Puppet.debug "#{key.lstrip} == #{inst_hash[key.lstrip]}"
    }
    # Puppet.debug pp inst_hash
    Puppet::Util::symbolizehash(inst_hash)
  end

  def self.doflush (xcat_type, prop_flush)
    if prop_flush
      cmd_list = ["-t", xcat_type, "-o", resource[:name]]
      if (prop_flush[:ensure] == :absent)
        # rmdef
        begin
          rmdef(cmd_list)
        rescue Puppet::ExecutionFailure => e
          raise Puppet::Error, "rmdef #{cmd_list} failed to run: #{e}"
        end
      else
        resource.to_hash.each { |key, value|
          if not [:name, :ensure, :provider, :loglevel, :before, :after].include?(key) 
            if value.is_a?(Array)
              value = value.join(",")
            end
            cmd_list += ["#{key}=#{value}"]
          end
        }
        if (prop_flush[:ensure] == :present)
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
    end
  end
end
