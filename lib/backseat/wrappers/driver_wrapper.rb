module Backseat
  module Wrappers
    class DriverWrapper < AbstractWrapper
    
      def initialize(driver=:htmlunit)
        unless Backseat.loaded
          raise BridgeLoadError.new('The Java libraries are not loaded. Did you call Backseat.load?') 
        end

        @driver = case driver
        when :firefox: Bridged.firefox.new
        when :safari:  Bridged.safari.new
        else Bridged.htmlunit.new
        end
        
        @element = @driver
        @identifier = nil
      end
    
      def_chainable_delegator :@element, :get
      def_delegator :@element, :getTitle, :get_title
      def_delegators :@element, :close
    
    end
  end
end