module Backseat::Helpers
  def self.included(base)
    base.send :include, XpathHelper
    base.send :include, WaitHelper
    base.send :include, ByHelper
  end
end