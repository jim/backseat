module Backseat::Helpers::ByHelper
  def by
    Rjb::import('org.openqa.selenium.By')
  end
end