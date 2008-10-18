module Backseat
  module Wrappers
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
      def_delegator :@element, :isDisplayed, :displayed?
    end
  end
end