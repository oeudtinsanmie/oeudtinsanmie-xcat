require File.expand_path(File.join(File.dirname(__FILE__), '..', 'xcatobject'))
Puppet::Type.type(:xcat_node).provide(:xcat, :parent => Puppet::Provider::XCatObject) do

  mk_resource_methods
  
  def xcat_type = "node"
  
  def initialize(value={})
    super(value)
    @property_flush = {}
  end
            
  def self.instances
    # lsdef
    
    list_obj(xcat_type).collect { |obj|
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
  
  def flush
    doflush(xcat_type)
  end
end

