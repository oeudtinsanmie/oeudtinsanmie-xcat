class Puppet::Provider::XCat_Table < Puppet::Provider

  commands  :chtab   => /opt/xcat/sbin/chtab,
            :tabdump => /opt/xcat/sbin/tabdump

end
