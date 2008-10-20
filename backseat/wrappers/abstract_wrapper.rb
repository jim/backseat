require 'forwardable'

module Backseat
  module Wrappers
    class AbstractWrapper

      class_eval do
        def self.def_chainable_delegator(instance_var, method, new_name=nil)
          new_name ||= method
          class_eval <<-STR
            def #{new_name}(*args)
              instance_variable_get(:#{instance_var}).send(:#{method}, *args)
              self
            end
          STR
        end
      end
    
      extend Forwardable
    
      attr :driver
      attr :element
    
      def initialize(driver, element, identifier)
        @driver = driver
        @element = element
        @identifier = identifier
      end

      def has_child?(query)
        standardized = query.is_a?(XpathLocator) ? by.xpath(append_locator(query)) : query
        @element.findElements(standardized).toArray.size > 0
      end
    
      def find_element(query)
        standardized = query.is_a?(XpathLocator) ? by.xpath(append_locator(query)) : query
        ElementWrapper.new(@driver, @element.findElement(standardized), append_locator(query))
      end
    
      def find_elements(query)
        standardized = query.is_a?(XpathLocator) ? by.xpath(append_locator(query)) : query
        @element.findElements(standardized).toArray.map do |element|
          ElementWrapper.new(@driver, element, append_locator(query))
        end
      end
    
      def send_keys(*args)
        @element.sendKeys(args)
        self
      end
    
      def to_html
        # TODO
      end
    
      def [](arg)
        return attribute(arg) if arg.is_a? Symbol
        find_element(arg)
      end
    
      alias :/ :find_elements
    
      # this is mostly to support rspec's have matchers: have(x).elements(div(:class => 'huge'))
      alias :elements :find_elements
      
      protected
      
      def append_locator(suffix)
        @identifier.nil? ? suffix : "#{@identifier}#{suffix}"
      end
      
    end
  end
end