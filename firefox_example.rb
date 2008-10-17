require 'backseat'

include Backseat

Backseat.load!('/Users/jimb/src/webdriver/trunk')

driver = Backseat::Driver.new(:firefox)

driver.get('http://www.google.com/webhp?complete=1&hl=en')

element = driver.find_element input(:name => 'q')
element.send_keys('Cheese')

wait :until => lambda { driver.contains?(table(:class => 'gac_m')) &&
                        driver.find_element(table(:class => 'gac_m')).displayed? }

driver.find_elements(td(:class=> 'gac_c')).each do |e|
  puts e.text
end

driver.close # quit Firefox