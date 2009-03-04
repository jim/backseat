module Backseat
  module Helpers
    module WaitHelper
      # Expects to be passed a proc that will return a boolean as :until
      def wait(options={})
        proc = options[:until] || lambda { true }
        max = options[:max] || 10
        elapsed = 0
        while !proc.call do
          sleep 1
          elapsed += 1
          if elapsed == max
            raise WaitTimeoutError, "waited #{max} seconds to no avail"
          end
        end
      end
    end
  end
end