class Puppet::Provider::Xcattbl < Puppet::Provider

  # Without initvars commands won't work.
  initvars
  commands  :tabdump => '/opt/xcat/sbin/tabdump',
            :chtab => '/opt/xcat/sbin/chtab'  
         
  def initialize(value={})
    super(value)
    @property_flush = {}
  end

  def self.instances
    list_obj.collect { |obj|
      new(make_hash(obj))
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

  def self.list_obj
    begin
      output = tabdump(xcat_tbl)
    rescue Puppet::ExecutionFailure => e
      raise Puppet::DevError, "tabdump #{xcat_tbl} had an error -> #{e.inspect}"
    end
    
    entry_strs = output.split("\n")
    self.tblkeys = output.delete_at(0)
    entry_strs
  end

  def self.make_hash(entry_str)
    inst_hash = {}
    tblvals = entry_str.split(",")
    tblkeys.each { | key |
      tblvals[0].delete! "\""
      if (tblvals[0].include? ",") then
        inst_hash[key] = tblvals.delete_at(0).split(',')
      else
        inst_hash[key] = tblvals.delete_at(0)
      end
      if (inst_hash[key] == '') then
        inst_hash[key] = nil
      end
    }
    Puppet::Util::symbolizehash(inst_hash)
  end
  
  def flush
    if (@property_flush[:ensure] == :absent) then
      cmd_list = [ "-d", "#{self.class.keycolumn}=#{resource[:name]}", ]
    else
      cmd_list = [ "#{self.class.keycolumn}=#{resource[:name]}", ]
      resource.to_hash.each { |key, value|
        if not [:name, :ensure, :provider, :loglevel, :before, :after].include?(key)
          if (value.is_a?(Array)) then 
            cmd_list += ["#{self.class.xcat_tbl}.#{key}=#{value.join(',')}"]
            Puppet.debug "Setting #{self.class.xcat_tbl}.#{key} = #{value.join(',')}"
          else
            Puppet.debug "Setting #{self.class.xcat_tbl}.#{key} = #{value}"
            cmd_list += ["#{self.class.xcat_tbl}.#{key}=#{value}"]
          end
        end
      }
    end
    begin
      output = chtab(cmd_list)
    rescue Puppet::ExecutionFailure => e
      raise Puppet::DevError, "chtab #{cmd_list.join(' ')} had an error -> #{e.inspect}"
    end
    
  end
  
end