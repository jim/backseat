module Backseat
  module Helpers
    module XpathHelper

      TAGS = %w(h1 h2 h3 h4 h5 h6 div span img button input textarea ul ol li form a p object select table td tr)
    
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
      
        TAGS.each do |tag|
          class_eval <<-STR
            def #{tag}(identifier={})
              XpathLocator.construct('#{tag}', identifier)
            end
          STR
        end
            
      end
      
      TAGS.each do |tag|
        module_eval <<-STR
          def #{tag}(identifier={})
            XpathLocator.construct('#{tag}', identifier)
          end
        STR
      end
     
    end
  end
end