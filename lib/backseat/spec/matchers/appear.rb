module Backseat
  module Spec
    module Matchers
      class Appear
        def initialize(driver)
          @driver = driver
          @within = 10
        end

        def matches?(element)
          @element = element
          @driver.exist?(element).should be_true
          @driver.find_element(element).should_not be_displayed
        
          @within.times do
            sleep 1
            break if @driver.find_element(element).displayed?
          end
          @driver.find_element(element).should be_displayed
          true
        end

        def failure_message
          "expected #{@element.inspect} to appear within #{@within} seconds, but it didn't"
        end

        def negative_failure_message
          "expected #{@element.inspect} not to appear #{@within} seconds, but it did"
        end
      
        def within(seconds)
          @within = seconds.to_i
        end
      end

      def appear(expected)
        Appear.new(expected)
      end
    end
  end
end