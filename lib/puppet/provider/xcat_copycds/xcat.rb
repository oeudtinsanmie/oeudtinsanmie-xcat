Puppet::Type.type(:xcat_copycds).provide(:xcat) do

  commands  :copycds => '/opt/xcat/sbin/copycds',
	    :find    => '/bin/find',
            :rm      => 'rm'

  mk_resource_methods            
  @ignore_dirs = [
  	"lost+found",
  	"prescripts",
  	"postscripts",
  	"winpostscripts",
  	"autoinst",
  	]

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
    mindepth = 2
    
    cmd_list = [ root, "-maxdepth" , maxdepth, "-mindepth", mindepth ]
    begin
      output = find(cmd_list)
    rescue Puppet::ExecutionFailure => e
      raise Puppet::DevError, "find #{cmd_list.join(' ')} had an error -> #{e.inspect}"
    end

    obj_strs = output.lines.select { |s| 
      validEntry? s
    }
  end
  
  def self.validEntry? (s) 
    if s.count("/") <= 2 
      return false
    end
    @ignore_dirs.each { | ign |
      if s.include? ign 
        return false
      end
    }
    true
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
