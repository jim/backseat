require 'rubygems'
require 'rjb'

require File.expand_path(File.dirname(__FILE__) + '/backseat/element_wrapper')
require File.expand_path(File.dirname(__FILE__) + '/backseat/driver')
require File.expand_path(File.dirname(__FILE__) + '/backseat/xpath_helpers')

module Backseat

  include XpathHelpers

  module BridgedDrivers
    (class << self; self; end).class_eval do
      attr_accessor :firefox
      attr_accessor :htmlunit
      attr_accessor :safari
    end
  end

  def self.load!(webdriver_root=nil)
    
    raise 'load! must be called with the absolute path to a built webdriver checkout' if webdriver_root.nil?
    
    module_eval do
      libs = []
      libs << webdriver_root + '/common/build/webdriver-common.jar'
      libs << webdriver_root + '/htmlunit/build/webdriver-htmlunit.jar'
      libs.concat(Dir[webdriver_root + '/htmlunit/lib/runtime/*'])

      Rjb::load(libs.join(':'))

      # WebDriver = Rjb::import('org.openqa.selenium.WebDriver')
      # WebElement = Rjb::import('org.openqa.selenium.WebElement')
      BridgedDrivers.htmlunit = Rjb::import('org.openqa.selenium.htmlunit.HtmlUnitDriver')
      # FirefoxDriver = Rjb::import('org.openqa.selenium.firefox.FirefoxDriver')
    end
    
    class_eval do
      def by
        Rjb::import('org.openqa.selenium.By')
      end
    end
  end
  
end