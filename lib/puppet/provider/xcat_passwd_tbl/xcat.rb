require File.expand_path(File.join(File.dirname(__FILE__), '..', 'xcattbl'))
Puppet::Type.type(:xcat_passwd_tbl).provide(:xcat, :parent => Puppet::Provider::Xcattbl) do

  mk_resource_methods

  def self.xcat_tbl
    "passwd"
  end
  
  def self.keycolumn
    "key"
  end

end

