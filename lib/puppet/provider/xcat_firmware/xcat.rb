require File.expand_path(File.join(File.dirname(__FILE__), '..', 'xcatobject'))
Puppet::Type.type(:xcat_osimage).provide(:xcat, :parent => Puppet::Provider::XCatObject) do

  mk_resource_methods
  
  def xcat_type
    "firmware"
  end
  
end
