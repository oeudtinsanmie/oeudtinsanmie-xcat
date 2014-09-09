require 'pp'
Puppet::Type.type(:xcat_site_attribute).provide(:xcat) do

  mk_resource_methods
  
  def self.instances
    list_obj.collect { |obj|
      new(make_hash(obj))
    }
  end
  
  def flush
    if resource[:value].kind_of?(Array)
      value = resource[:value].join(',')
    else
      value = resource[:value]
    end
    cmd_list = ["-t", "site", "-o", resource[:sitename], "#{resource[:name]}=#{value}"]
    begin
      chdef(cmd_list)
    rescue Puppet::ExecutionFailure => e
      raise Puppet::Error, "chdef #{cmd_list.join(' ')} failed to run: #{e}"
    end
  end
  
  commands  :lsdef => '/opt/xcat/bin/lsdef',
            :mkdef => '/opt/xcat/bin/mkdef',
            :rmdef => '/opt/xcat/bin/rmdef',
            :chdef => '/opt/xcat/bin/chdef'
            
  def initialize(value={})
    super(value)
  end
  
  def self.list_obj
    cmd_list = ["-l", "-t", "site"]

    begin
      output = lsdef(cmd_list)
    rescue Puppet::ExecutionFailure => e
      Puppet.debug "lsdef had an error -> #{e.inspect}"
      return {}
    end
    
    objstrs = []
    site_strs = output.split("Object name: ")
    site_strs.delete("")
    site_strs.each { |site|
      hash_list = site.split("\n")
      sitename = hash_list.shift
      hash_list.each { |objstr|
        objstrs += [ "#{sitename}=#{objstr}" ]
      }
    }
    objstrs
  end
  
  def self.make_hash(obj_str)
    inst_hash = {}
    inst_hash[:ensure] = :present
    site, key, value = obj_str.split("=")
    key = key.lstrip
    
    inst_hash[:sitename] = site
    inst_hash[:name] = key
      
    if (value.include? ",") then 
      inst_hash[:value] = value.split(",")
    else
      inst_hash[:value] = value
    end
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
    @property_hash[:ensure] = :present
  end
  
  def destroy
    @property_hash[:ensure] = :absent
  end
end

