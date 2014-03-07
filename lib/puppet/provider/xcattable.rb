class Puppet::Provider::XCatTable < Puppet::Provider

  commands  :chtab   => /opt/xcat/sbin/chtab,
            :tabdump => /opt/xcat/sbin/tabdump

end
