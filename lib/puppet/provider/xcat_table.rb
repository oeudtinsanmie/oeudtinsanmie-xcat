class Puppet::Provider::xcat_table < Puppet::Provider

  commands  :chtab   => /opt/xcat/sbin/chtab,
            :tabdump => /opt/xcat/sbin/tabdump

end
