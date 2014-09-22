class Puppet::Provider::Xcatprovider < Puppet::Provider
  def self.puppetkeywords
    [:name, :ensure, :provider, :loglevel, :before, :after, :test]
  end
end

