Puppet::Type.type(:xcat_copycds).provide(:xcat) do

  mk_resource_methods

  commands  :copycds => '/opt/xcat/sbin/copycds',
	    :find    => '/bin/find',
            :rm      => 'rm'
            
  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def self.instances
    # lsdef
    
    list_obj.collect { |obj|
      new(make_hash(obj))
    }
  end

  def self.list_obj
    root = "/install"
    maxdepth = 2
    mindepth = 1
    if (distro != nil)
      root += "/#{distro}"
      maxdepth = 1
      mindepth = 0
      if (arch != nil)
        root += "/#{arch}"
        maxdepth = 0
      end
    end

    cmd_list = [root, "-maxdepth" , maxdepth, "-mindepth", mindepth, "-type", "d" ,"\\( -path /install/lost+found -o -path /install/prescripts -o -path /install/postscripts \\)", "-prune", "-o", "-print"]
    begin
      output = find(cmd_list)
    rescue Puppet::ExecutionFailure => e
      Puppet.debug "find #{cmd_list} had an error -> #{e.inspect}"
      return {}
    end

    obj_strs = output.lines.select { |s| s.count("/") > 2 }
  end

  def self.make_hash(obj_str)
    if (obj_str == nil) 
      return {}
    end
    obj_str = obj_str[9..-1]
    hash_list = obj_str.split("/")
    if hash_list.length < 2
      return {}
    end
    inst_hash = Hash.new
    inst_hash[:distro] = hash_list[0]
    inst_hash[:arch]   = hash_list[1]
    inst_hash[:ensure] = :present
    inst_hash[:name] = "#{inst_hash[:distro]}-#{inst_hash[:arch]}"
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
    if (@property_flush and @property_flush[:ensure] == :absent)
      # rmdef
      root = "/install"
      if (resource[:distro] != nil) 
      	root += "/#{resource[:distro]}"
	if (resource[:arch] != nill) 
          root += "/#{resource[:arch]}"
	end
	begin
	  cmd_list = ["-rf", root]
	rescue Puppet::ExecutionFailure => e
	  raise Puppet::Error, "rm #{cmd_list} failed to run: #{e}"
	end
      end
    else
      begin
        cmd_list = ["-n", resource[:distro], "-a", resource[:arch], resource[:file]]
        copycds(cmd_list)
      rescue Puppet::ExecutionFailure => e
        raise Puppet::Error, "copycds #{cmd_list} failed to run: #{e}"
      end
    end      
  end
end
