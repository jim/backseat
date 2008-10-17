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
      
      %w(h1 h2 h3 h4 h5 h6 div span img button input textarea ul ol li form a p object select table td tr).each do |element|
        class_eval do
          define_method(element) do |identifier|
            self.class.construct(element, self, identifier)
          end
        end
      end
            
    end
      
    %w(h1 h2 h3 h4 h5 h6 div span img button input textarea ul ol li form a p object select table td tr).each do |element|
      module_eval do
        define_method(element) do |identifier|
          XpathLocator.construct(element, identifier)
        end
      end
    end
     
  end
end