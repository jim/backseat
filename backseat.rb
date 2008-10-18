require 'rubygems'
require 'rjb'

require 'backseat/wrappers/abstract_wrapper'
require 'backseat/wrappers/element_wrapper'
require 'backseat/wrappers/driver_wrapper'
require 'backseat/helpers/xpath_helper'
require 'backseat/helpers/wait_helper'

module Backseat

  class WaitTimeoutError < StandardError; end

  include Helpers::XpathHelper
  include Helpers::WaitHelper

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
  
  Driver = Backseat::Wrappers::DriverWrapper
  
end