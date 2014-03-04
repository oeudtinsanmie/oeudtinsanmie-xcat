require File.expand_path(File.join(File.dirname(__FILE__), '..', 'xcat_object'))
Puppet::Type.type(:xcat_osimage).provide(:xcat, :parent => Puppet::Provider::xcat_object) do
  
  def xcat_type
    "osdistro"
  end
  
end
