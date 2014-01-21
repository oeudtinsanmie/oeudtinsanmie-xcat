# This has to be a separate type to enable collecting
Puppet::Type.newtype(:xcat_site) do
  @doc = 'Manage the xcat site table.'

  newparam(:name, :namevar=>true) do
    desc 'Does nothing.'
  end

  newproperty(:installdir) do
    desc 'Install directory.'
  end

  newproperty(:forwarders) do
    desc 'DNS Forwarders.'
  end

  newproperty(:dhcpinterfaces) do
    desc 'DHCP Interfaces.'
  end

  newproperty(:master) do
    desc 'IP of master node.'
  end

  newproperty(:nameservers) do
    desc 'IPs of nameservers (default: master node).'
  end

  newproperty(:nodesyncfiledir) do
    desc 'Directory for node syncing.'
  end

  newproperty(:tftpdir) do
    desc 'TFTP directory.'
  end

  newproperty(:xcatport) do
    desc 'XCat Port.'
  end

  newproperty(:xcatiport) do
    desc 'XCat IPort.'
  end

  newproperty(:timezone) do
    desc 'Timezone.'
  end

  newproperty(:sshbetweennodes) do
    desc 'SSH Between Nodes setting.  See XCat documentation for valid settings.'
  end

  newproperty(:dhcplease) do
    desc 'lease time for the dhcp client.'
  end

end
