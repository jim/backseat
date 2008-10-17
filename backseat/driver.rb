require 'forwardable'

module Backseat
  class Driver < ElementWrapper
  
    def initialize(driver=:htmlunit)
      @driver = case driver
      when :firefox: BridgedDrivers.firefox.new
      when :safari:  BridgedDrivers.safari.new
      else BridgedDrivers.htmlunit.new
      end
      @element = @driver
    end
  
    def_delegators :@driver, :get
  
  end
end