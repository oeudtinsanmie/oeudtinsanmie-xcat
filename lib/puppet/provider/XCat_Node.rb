class Puppet::Provider::XCat_Node < Puppet::Provider

  commands  :nodels => /opt/xcat/sbin/nodels,
            :nodech => /opt.xcat/sbin/nodech

end
