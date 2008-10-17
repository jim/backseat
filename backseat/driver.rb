module Backseat
  class Driver < AbstractWrapper
    
    def initialize(driver=:htmlunit)
      @driver = case driver
      when :firefox: BridgedDrivers.firefox.new
      when :safari:  BridgedDrivers.safari.new
      else BridgedDrivers.htmlunit.new
      end
      @element = @driver
    end
    
    def_chainable_delegator :@element, :get
    def_delegator :@element, :getTitle, :get_title
    
  end
end