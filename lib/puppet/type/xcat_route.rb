# This has to be a separate type to enable collecting
Puppet::Type.newtype(:xcat_route) do
  @doc = 'a logical object definition in the xCAT database.'

  ensurable
  
  newparam(:routename, :namevar=>true) do
    desc 'Name used to identify this route.'
  end

  newparam(:gateway) do
    desc 'The gateway that routes the ip traffic from the mn to the nodes. It is usually a service node.'
  end
  
  newproperty(:usercomment) do 
    desc 'Any user-written notes.'
  end

  newproperty(:ifname) do
    desc 'The interface name that facing the gateway. It is optional for IPv4 routes, but it is required for IPv6 routes.'
  end

  newproperty(:mask) do
    desc 'The network mask.'
  end

  newproperty(:net) do
    desc 'The network address.'
  end

end
