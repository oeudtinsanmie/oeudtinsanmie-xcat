require File.expand_path(File.join(File.dirname(__FILE__), '..', 'xcat_object'))
Puppet::Type.type(:xcat_osimage).provide(:xcat, :parent => Puppet::Provider::xcat_object) do

  mk_resource_methods
  
  def xcat_type
    "firmware"
  end
  
end
