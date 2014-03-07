Puppet::Type.type(:xcat_node).provide(:xcat) do

  mk_resource_methods
  
  def self.xcat_type
    "node"
  end
  
  def xcat_type
    "node"
  end

  commands  :lsdef => '/opt/xcat/bin/lsdef',
            :mkdef => '/opt/xcat/bin/mkdef',
            :rmdef => '/opt/xcat/bin/rmdef',
            :chdef => '/opt/xcat/bin/chdef'
            
  def initialize(value={})
    super(value)
    @property_flush = {}
  end
            
  def self.instances
    # lsdef
    
    list_obj().collect { |obj|
      new(make_hash(obj))
    }
  end
  
  def list_obj (obj_name = nil)
    cmd_list = ["-l", "-t", xcat_type()]
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

  def self.list_obj (obj_name = nil)
    cmd_list = ["-l", "-t", xcat_type()]
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
      inst_hash[key.lstrip] = value
    }
    inst_hash
  end
  
  def make_hash(obj_str)
    hash_list = obj_str.split("\n")
    inst_name = hash_list.shift
    inst_hash = Hash.new
    inst_hash[:name]   = inst_name
    inst_hash[:ensure] = :present
    hash_list.each { |line|
      key, value = line.split("=")
      inst_hash[key.lstrip] = value
    }
    inst_hash
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
  
  def flush
    if @property_flush
      cmd_list = ["-t", self.xcat_type(), "-o", resource[:name]]
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
          if not [:name, :ensure, :provider, :loglevel].include?(key) 
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
    @property_hash = self.make_hash(list_obj(:name)[0])
  end
end

