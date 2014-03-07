require File.expand_path(File.join(File.dirname(__FILE__), '..', 'XCat_Object'))
Puppet::Type.type(:xcat_osimage).provide(:xcat, :parent => Puppet::Provider::XCat_Object) do
  
  def xcat_type
    "boottarget"
  end
  
end
