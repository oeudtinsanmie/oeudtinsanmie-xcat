module Puppet::Parser::Functions
  newfunction(:xcat_script, :type => :rvalue) do |args|
    xcatroot  = args[0]
    name      = args[1]
    
    "#{xcatroot}/share/xcat/install/scripts/#{name}"
  end
end