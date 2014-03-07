require File.expand_path(File.join(File.dirname(__FILE__), '..', 'xcatobject'))
Puppet::Type.type(:xcat_osimage).provide(:xcat, :parent => Puppet::Provider::XCatObject) do
  
  def xcat_type
    "boottarget"
  end
  
end
