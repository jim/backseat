module Backseat
  module XpathHelpers
    
    class XpathLocator < String
      
      def self.construct(*args)
        identifier = args.last.is_a?(Hash) ? args.pop : {}
        tag = args[0].to_s
        scope = args[1] || ''
        locator = scope + '//' + tag
        attribute_selectors = identifier.map do |attribute, value|
          attribute = attribute == :text ? '.' : '@'+attribute.to_s
          value.respond_to?(:to_xpath) ? value.to_xpath(attribute) : "#{attribute.to_s}='#{value.to_s}'"
        end
        locator += '[' + attribute_selectors.join(' and ') + ']' unless attribute_selectors.empty?
        XpathLocator.new(locator)
      end
      
      %w(h1 h2 h3 h4 h5 h6 div span img button input textarea ul ol li form a p object select).each do |element|
        class_eval do
          define_method(element) do |identifier|
            self.class.construct(element, self, identifier)
          end
        end
      end
            
    end
      
    #   attr :tag
    #   attr :identifier
    #   attr :scope
    #   attr :driver
    #   def initialize(driver, tag, identifier={}, scope=nil)
    #     @driver = driver
    #     @tag = tag
    #     @identifier = identifier
    #     @scope = scope || ''
    #   end
    # 
    #   def element?; true; end
    # 
    #   # child text node accessor
    #   def text; raise 'not yet implemented'; end
    # 
    #   # html attribute accessor - not tested
    #   def [](attribute)
    #     browser.get_attribute(locator + "@#{attribute}")  
    #   end    
    # 
    # 
    # 
    #   def describe
    #     identifier_description = identifier.map do |attribute,value|
    #       if value.respond_to?(:to_xpath)
    #         "#{attribute.to_s} matching XPath '#{value.to_xpath(attribute)}'"
    #       else
    #         "#{attribute.to_s} of '#{value.to_s}'"
    #       end
    #     end.join(" and ")
    #     "<#{tag}> with #{identifier_description}"
    #   end
    # end

    %w(h1 h2 h3 h4 h5 h6 div span img button input textarea ul ol li form a p object select).each do |element|
      module_eval do
        define_method(element) do |identifier|
          XpathLocator.construct(element, identifier)
        end
      end
    end
    # 
    # def tag(identifier)
    #   PageElement.new(@browser, '*', merge_attribute_sets(current_attributes, identifier), current_scope)
    # end
    # 
    # def within(element, &block)
    #   raise ArgumentError, "within requires a block" unless block_given?
    #   element.should be_present
    #   @parent_nodes ||= []
    #   @parent_nodes << element
    #   yield
    #   @parent_nodes.pop
    # end
    # 
    # def current_scope
    #   @parent_nodes ||= []
    #   @parent_nodes.map{|node|node.locator}.join
    # end
    # 
    # def current_attributes
    #   @with_attributes_attribute_sets ||= []
    #   @with_attributes_attribute_sets.last
    # end
    # 
    # def with_attributes(attributes={}, &block)
    #   raise ArgumentError, "with_attributes requires a block" unless block_given?
    #   @with_attributes_attribute_sets ||= []
    #   @with_attributes_attribute_sets << merge_attribute_sets(current_attributes, attributes)
    #   yield
    #   @with_attributes_attribute_sets.pop
    # end
    # 
    # alias :cascade :with_attributes
    # 
    # def merge_attribute_sets(old_attributes, new_attributes={})
    #   old_attributes ||= {}
    #   new_attributes.each_pair do |key, value|
    #     value = value.to_s if value.is_a? Symbol
    #     if old_attributes[key]
    #       case key.to_sym
    #       when :name
    #         value = [value] unless value.is_a? Array
    #         new_name = value.map{|v| "[#{value}]"}.join
    #         new_attributes[:name] = old_attributes[:name] + new_name
    #       when :class
    #         new_attributes[:class] = old_attributes[:class].is_a? Array ? old_attributes[:class] : [old_attributes[:class]]
    #         new_attributes[:class] << value
    #       else
    #         # overwrite anything else
    #         new_attributes[key] = value
    #       end
    #     else
    #       new_attributes[key] = value
    #     end
    #   end
    #   new_attributes
    # end
    
  end
end