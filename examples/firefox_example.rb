require 'backseat'
include Backseat::Helpers

Backseat.load!

def wait_until_visible(element)
  wait :until => lambda { @driver.has_child?(element) &&
                          @driver.find_element(element).displayed? }
end

@driver = Backseat::Driver.new(:firefox)

@driver.get('http://www.google.com/webhp?complete=1&hl=en')

element = @driver.find_element input(:name => 'q')
element.send_keys('Cheese')

wait_until_visible table(:class => 'gac_m')

@driver.find_elements(td(:class=> 'gac_c')).each do |e|
  puts e.text
end

@driver.close # quit Firefox