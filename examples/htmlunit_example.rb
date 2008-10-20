require 'backseat'
include Backseat

Backseat.load!

driver = Backseat::Driver.new(:htmlunit)

driver.get('http://www.google.com')

element = driver.find_element input(:name => 'q')
element.send_keys('Cheese!').submit

puts "Page title is: #{driver.get_title}"