require 'backseat'
include Backseat

Backseat.webdriver_root = '/Users/jimb/src/webdriver/trunk'
Backseat.load!

driver = Backseat::Driver.new(:htmlunit)
driver.get('http://www.google.com')

element = driver.find_element(by.name("q"))

element.send_keys('Cheese!')
element.submit()

driver.find_elements(by.xpath("//div[@id='res']//a[@class='l']")).each do |a|
  puts a.attribute(:href)
end