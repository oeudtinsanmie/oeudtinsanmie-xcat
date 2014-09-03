class Puppet::Provider::Xcatobject < Puppet::Provider

  # Without initvars commands won't work.
  initvars
  commands  :lsdef => '/opt/xcat/bin/lsdef',
            :mkdef => '/opt/xcat/bin/mkdef',
            :rmdef => '/opt/xcat/bin/rmdef',
            :chdef => '/opt/xcat/bin/chdef'  

  def self.instances
    list_obj.collect { |obj|
      new(make_hash(obj))
    }
  end
  
  def self.prefetch(resources)
    instances.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end
  
  def create
    @property_flush[:ensure] = :present
  end
  
  def destroy
    @property_flush[:ensure] = :absent
  end

  def self.list_obj
    cmd_list = ["-l", "-t", @xcat_type]
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
    }
    Puppet::Util::symbolizehash(inst_hash)
  end

  def flush
    cmd_list = ["-t", @xcat_type, "-o", resource[:name]]
    if (@property_flush and @property_flush[:ensure] == :absent)
      # rmdef
      begin
        rmdef(cmd_list)
        @property_flush = nil
      rescue Puppet::ExecutionFailure => e
        raise Puppet::Error, "rmdef #{cmd_list} failed to run: #{e}"
      end
    else
      resource.to_hash.each { |key, value|
        if not [:name, :ensure, :provider, :loglevel, :before, :after].include?(key)
          if value.is_a?(Array)
            Puppet.debug "Setting #{key} = #{value.join(',')}"
            cmd_list += ["#{key}=#{value.join(',')}"]
          else
            Puppet.debug "Setting #{key} = #{value}"
            cmd_list += ["#{key}=#{value}"]
          end
        end
      }
      if (@property_flush and @property_flush[:ensure] == :present)
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
