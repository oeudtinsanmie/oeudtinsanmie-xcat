# This has to be a separate type to enable collecting
Puppet::Type.newtype(:boottarget) do
  @doc = 'Specify non-standard initrd, kernel, and parameters that should be used for a given profile.'

  newparam(:name, :namevar=>true) do
    desc 'bprofile  All nodes with a nodetype.profile value equal to this value
                 and nodetype.os set to "boottarget", will use the associated
                 kernel, initrd, and kcmdline.'
  end

  newparam(:kernel) do
    desc 'The kernel that network boot actions should currently acquire
                 and use.  Note this could be a chained boot loader such as
                 memdisk or a non-linux boot loader'
  end
  
  newproperty(:initrd) do
    desc 'The initial ramdisk image that network boot actions should
                 use (could be a DOS floppy or hard drive image if using
                 memdisk as kernel)'
  end

  newproperty(:kcmdline) do
    desc 'Arguments to be passed to the kernel'
  end

  newproperty(:comments) do 
    desc 'Any user-written notes.'
  end

  newproperty(:disable) do
    desc 'Set to ’yes’ or ’1’ to comment out this row.'
  end

end
