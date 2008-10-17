require 'forwardable'

module Backseat
  class ElementWrapper
    
    extend Forwardable
    
    attr :driver
    attr :element
    
    def initialize(driver, element)
      @driver = driver
      @element = element
    end
    
    def attribute(name)
      @element.getAttribute(name.to_s)
    end
    
    def find_element(by)
      ElementWrapper.new(@driver, @element.findElement(by))
    end
    
    def find_elements(by)
      @element.findElements(by).toArray.map do |element|
        ElementWrapper.new(@driver, element)
      end
    end
    
    def send_keys(*args)
      @element.sendKeys(args)
    end
    
    def to_html
      # TODO
    end
    
    def_delegators :@element, :click, :clear, :submit, :toggle
    def_delegator :@element, :getText, :text
    def_delegator :@element, :getValue, :value
    def_delegator :@element, :isSelected, :selected?
    def_delegator :@element, :isEnabled, :enabled?
    def_delegator :@element, :setSelected, :select
    
  end
end