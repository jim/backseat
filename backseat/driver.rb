module Backseat
  class Driver < AbstractWrapper
    
    def initialize(driver=:htmlunit)
      @driver = case driver
      when :firefox: Bridged.firefox.new
      when :safari:  Bridged.safari.new
      else Bridged.htmlunit.new
      end
      @element = @driver
    end
    
    def_chainable_delegator :@element, :get
    def_delegator :@element, :getTitle, :get_title
    def_delegators :@element, :close
    
  end
end