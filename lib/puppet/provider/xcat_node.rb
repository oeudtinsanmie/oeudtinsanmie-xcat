class Puppet::Provider::xcat_node < Puppet::Provider

  commands  :nodels => /opt/xcat/sbin/nodels,
            :nodech => /opt.xcat/sbin/nodech

end
