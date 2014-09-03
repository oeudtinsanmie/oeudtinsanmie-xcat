require 'pp'
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'xcatobject'))
Puppet::Type.type(:xcat_node).provide(:xcat, :parent => Puppet::Provider::Xcatobject) do

  mk_resource_methods
  
  @xcat_type = "node"
  
  def self.instances
    list_obj(@xcat_type).collect { |obj|
      new(obj)
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
    Puppet.debug "Flushing changes:"
    doflush
    Puppet.debug "whew"
    pp resource.to_hash
    # refresh @property_hash
  end
end

