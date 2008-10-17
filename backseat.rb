require 'rubygems'
require 'rjb'

require File.expand_path(File.dirname(__FILE__) + '/backseat/element_wrapper')
require File.expand_path(File.dirname(__FILE__) + '/backseat/driver')
require File.expand_path(File.dirname(__FILE__) + '/backseat/xpath_helpers')

module Backseat

  class WaitTimeoutError < StandardError; end

  include XpathHelpers

  module Bridged
    (class << self; self; end).class_eval do
      attr_accessor :firefox
      attr_accessor :htmlunit
      attr_accessor :safari
      attr_accessor :rendered_web_element
    end
  end

  def self.load!(webdriver_root=nil)
    
    raise 'load! must be called with the absolute path to a built webdriver checkout' if webdriver_root.nil?
    
    module_eval do
      libs = []
      libs << webdriver_root + '/common/build/webdriver-common.jar'
      libs << webdriver_root + '/htmlunit/build/webdriver-htmlunit.jar'
      libs.concat(Dir[webdriver_root + '/htmlunit/lib/runtime/*'])
      libs.concat(Dir[webdriver_root + '/firefox/build/*'])
      libs.concat(Dir[webdriver_root + '/firefox/lib/runtime/*'])
      Rjb::load(libs.join(':'))

      # WebDriver = Rjb::import('org.openqa.selenium.WebDriver')
      # WebElement = Rjb::import('org.openqa.selenium.WebElement')
      Bridged.htmlunit = Rjb::import('org.openqa.selenium.htmlunit.HtmlUnitDriver')
      Bridged.firefox = Rjb::import('org.openqa.selenium.firefox.FirefoxDriver')
      Bridged.rendered_web_element = Rjb::import('org.openqa.selenium.RenderedWebElement')
    end
    
    class_eval do
      def by
        Rjb::import('org.openqa.selenium.By')
      end
    end
  end
  
  def wait(options={})
    proc = options[:until]
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