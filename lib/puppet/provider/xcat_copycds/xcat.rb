require 'pp'
Puppet::Type.type(:xcat_copycds).provide(:xcat) do

  commands  :copycds => '/opt/xcat/sbin/copycds',
	    :find    => '/bin/find',
            :rm      => 'rm'

  mk_resource_methods            

  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def self.instances
    # lsdef
    p "Instances: ..."
    list_obj.collect { |obj|
      new(make_hash(obj))
    }
  end

  def self.list_obj
    p "Collecting list of obj"
    root = "/install"
    maxdepth = 2
    mindepth = 1

    cmd_list = [root, "-maxdepth" , maxdepth, "-mindepth", mindepth, "-type", "d" ,"\\( -path /install/lost+found -o -path /install/prescripts -o -path /install/postscripts \\)", "-prune", "-o", "-print"]
    begin
      p "find #{cmd_list.join(' ')}"
      output = find(cmd_list)
    rescue Puppet::ExecutionFailure => e
      p "find #{cmd_list.join(' ')} had an error -> #{e.inspect}"
      raise Puppet::DevError, "find #{cmd_list.join(' ')} had an error -> #{e.inspect}"
    end

    obj_strs = output.lines.select { |s| s.count("/") > 2 }
    p obj_strs
    obj_strs
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
    pp inst_hash
    inst_hash
  end

  def self.prefetch(resources)
    p "Prefetching"
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
