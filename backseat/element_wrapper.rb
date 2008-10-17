require 'forwardable'

module Backseat
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
    
    def initialize(driver, element)
      @driver = driver
      @element = element
    end
    
    def find_element(query)
      query = by.xpath(query) if query.is_a? XpathLocator
      ElementWrapper.new(@driver, @element.findElement(query))
    end
    
    def find_elements(query)
      query = by.xpath(query) if query.is_a? XpathLocator
      @element.findElements(query).toArray.map do |element|
        ElementWrapper.new(@driver, element)
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
    
  end
  
  class ElementWrapper < AbstractWrapper
    
    def attribute(name)
      @element.getAttribute(name.to_s)
    end
    
    def_chainable_delegator :@element, :clear
    def_chainable_delegator :@element, :click
    def_chainable_delegator :@element, :submit
    def_chainable_delegator :@element, :toggle
    def_chainable_delegator :@element, :setSelected, :select
    
    def_delegator :@element, :getText, :text
    def_delegator :@element, :getValue, :value
    def_delegator :@element, :isSelected, :selected?
    def_delegator :@element, :isEnabled, :enabled?
       
  end
end