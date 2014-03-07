require File.expand_path(File.join(File.dirname(__FILE__), '..', 'xcatobject'))
Puppet::Type.type(:xcat_site_attribute).provide(:xcat, :parent => Puppet::Provider::XCatObject) do

  mk_resource_methods
  
  def self.instances
    # lsdef
    insts = Array.new
    list_obj().each { |obj|
      hsh = make_hash(obj)
      site = hsh.delete(:name)
      insts += hsh.collect { |key, value|
        keyvalue[:name]   = key
        keyvalue[:sitename] = site
        keyvalue[:value]  = value
        new(keyvalue)
      }
    }
    insts
  end
  
  def xcat_type
    "site"
  end
  
  def flush
    if @property_flush
      cmd_list = ["-t", xcat_type, "-o", resource[:sitename], "#{resource[:name]}=#{resource[:value]}"]
      begin
        chdef(cmd_list)
      rescue Puppet::ExecutionFailure => e
        raise Puppet::Error, "chdef #{cmd_list} failed to run: #{e}"
      end
      @property_flush = nil
    end
    # refresh @property_hash
    @property_hash = resource.to_hash
  end
end
