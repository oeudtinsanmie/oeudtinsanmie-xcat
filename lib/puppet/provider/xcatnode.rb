class Puppet::Provider::XCatNode < Puppet::Provider

  commands  :nodels => /opt/xcat/sbin/nodels,
            :nodech => /opt.xcat/sbin/nodech

end
