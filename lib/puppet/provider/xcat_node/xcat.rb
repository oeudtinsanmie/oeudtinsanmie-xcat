require File.expand_path(File.join(File.dirname(__FILE__), '..', 'xcatobject'))
Puppet::Type.type(:xcat_node).provide(:xcat, :parent => Puppet::Provider::Xcatobject) do

  mk_resource_methods

  @@xcat_type = "node"
  
end

