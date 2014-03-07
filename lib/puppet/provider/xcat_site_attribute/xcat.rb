Puppet::Type.type(:xcat_site_attribute).provide(:xcat, :parent => Puppet::Provider) do

  mk_resource_methods
  
  def self.instances
    # lsdef
    insts = Array.new
    list_obj().each { |obj|
      hsh = make_hash(obj)
      site = hsh.delete(:name)
      insts += hsh.collect { |key, value|
        keyvalue[:name]   = key
        keyvalue[:sitename] = site
        keyvalue[:value]  = value
        new(keyvalue)
      }
    }
    insts
  end
  
  def xcat_type
    "site"
  end
  
  def flush
    if @property_flush
      cmd_list = ["-t", xcat_type, "-o", resource[:sitename], "#{resource[:name]}=#{resource[:value]}"]
      begin
        chdef(cmd_list)
      rescue Puppet::ExecutionFailure => e
        raise Puppet::Error, "chdef #{cmd_list} failed to run: #{e}"
      end
      @property_flush = nil
    end
    # refresh @property_hash
    @property_hash = resource.to_hash
  end
  
  commands  :lsdef => '/opt/xcat/bin/lsdef',
            :mkdef => '/opt/xcat/bin/mkdef',
            :rmdef => '/opt/xcat/bin/rmdef',
            :chdef => '/opt/xcat/bin/chdef'
            
  def initialize(value={})
    super(value)
    @property_flush = {}
  end
  
  def list_obj (obj_name = nil)
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
    inst_name = hash.shift
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
end

