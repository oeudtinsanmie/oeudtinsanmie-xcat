class Puppet::Provider::xcat_object < Puppet::Provider

  commands  :lsdef => '/opt/xcat/bin/lsdef',
            :mkdef => '/opt/xcat/bin/mkdef',
            :rmdef => '/opt/xcat/bin/rmdef',
            :chdef => '/opt/xcat/bin/chdef'
            
  def self.instances |type| 
    
  end
  
  def exists?
    @property_hast[:ensure] == :present
  end
  
  # mk_resource_methods foreach child
  
  def create
  end
  
  def destroy
  end
  
  def flush
  end
end
