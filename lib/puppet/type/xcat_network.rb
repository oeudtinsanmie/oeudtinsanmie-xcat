# This has to be a separate type to enable collecting
Puppet::Type.newtype(:xcat_network) do
  @doc = 'a logical object definition in the xCAT database.'

  newparam(:netname, :namevar=>true) do
    desc 'Name used to identify this network definition.'
  end

  newparam(:ddnsdomain) do
    desc 'A domain to be combined with nodename to construct FQDN for DDNS updates induced by DHCP. This is not passed down to the client as "domain"'
  end
  
  newproperty(:dhcpserver) do
    desc 'The DHCP server that is servicing this network. Required to be explicitly set for pooled service node operation.'
  end

  newproperty(:domain) do
    desc 'The DNS domain name (ex. cluster.com).'
  end

  newproperty(:dynamicrange) do
    desc 'The IP address range used by DHCP to assign dynamic IP addresses for requests on this network. This should not overlap with entities expected to be configured with static host declarations, i.e. anything ever expected to be a node with an address registered in the mac table.'
  end
  
  newproperty(:gateway) do
    desc 'The network gateway. It can be set to an ip address or the keyword <xcatmaster>, the keyword <xcatmaster> indicates the cluster-facing ip address configured on this management node or service node. Leaving this field blank means that there is no gateway for this network.'
  end
  
  newproperty(:logservers) do
    desc 'The log servers for this network. Used in creating the DHCP network definition. Assumed to be the DHCP server if not set.'
  end
  
  newproperty(:mask) do
    desc 'The network mask.'
  end
  
  newproperty(:mgtifname) do
    desc 'The interface name of the management/service node facing this network. !remote! indicates a non-local network for relay DHCP.'
  end
  
  newproperty(:nameservers) do
    desc 'A comma delimited list of DNS servers that each node in this network should use. This value will end up in the nameserver settings of the /etc/resolv.conf on each node in this network. If this attribute value is set to the IP address of an xCAT node, make sure DNS is running on it. In a hierarchical cluster, you can also set this attribute to "<xcatmaster>" to mean the DNS server for each node in this network should be the node that is managing it (either its service node or the management node). Used in creating the DHCP network definition, and DNS configuration.'
  end
  
  newproperty(:net) do
    desc 'The network address.'
  end
  
  newproperty(:nodehostname) do
    desc 'A regular expression used to specify node name to network-specific hostname. i.e. "/\z/-secondary/" would mean that the hostname of "n1" would be n1-secondary on this network. By default, the nodename is assumed to equal the hostname, followed by nodename-interfacename.'
  end
  
  newproperty(:ntpservers) do
    desc 'The ntp servers for this network. Used in creating the DHCP network definition. Assumed to be the DHCP server if not set.'
  end
  
  newproperty(:staticrange) do
    desc 'The IP address range used to dynamically assign static IPs to newly discovered nodes. This should not overlap with the dynamicrange nor overlap with entities that were manually assigned static IPs. The format for the attribute value is: <startip>-<endip>.'
  end
  
  newproperty(:usercomment) do 
    desc 'Any user-written notes.'
  end

  newproperty(:staticrangeincrement) do
    desc '(networks.staticrangeincrement)'
  end
  
  newproperty(:tftpserver) do
    desc 'The TFTP server that is servicing this network. If not set, the DHCP server is assumed.'
  end
  
  newproperty(:vlanid) do
    desc 'The vlan ID if this network is within a vlan.'
  end

end
