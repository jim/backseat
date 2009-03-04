require 'rubygems'
require 'rjb'

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__))) unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))
require 'backseat/wrappers/abstract_wrapper'
require 'backseat/wrappers/element_wrapper'
require 'backseat/wrappers/driver_wrapper'
require 'backseat/helpers'
require 'backseat/helpers/xpath_helper'
require 'backseat/helpers/wait_helper'
require 'backseat/helpers/by_helper'
require 'backseat/server'

module Backseat
  
  VERSION = '0.0.2'

  (class << self; self; end).class_eval do
    attr_accessor :loaded
  end

  class WaitTimeoutError < StandardError; end
  class ConfigurationError < StandardError; end
  class BridgeLoadError < StandardError; end

  module Bridged
    (class << self; self; end).class_eval do
      attr_accessor :firefox
      attr_accessor :htmlunit
      attr_accessor :safari
      attr_accessor :rendered_web_element
    end
  end

  def self.load!(webdriver_root=nil)
    
    webdriver_root ||= ENV['WEBDRIVER_ROOT']
    
    if webdriver_root.nil?
      raise ConfigurationError.new('load! must be called with the absolute path to a built webdriver checkout or with a WEBDRIVER_ROOT env variable') 
    end
    
    module_eval do
      libs = []
      libs << webdriver_root + '/common/build/webdriver-common.jar'
      libs << webdriver_root + '/htmlunit/build/webdriver-htmlunit.jar'
      libs.concat(Dir[webdriver_root + '/htmlunit/lib/runtime/*'])
      libs.concat(Dir[webdriver_root + '/firefox/build/*'])
      libs.concat(Dir[webdriver_root + '/firefox/lib/runtime/*'])
      Rjb::load(libs.join(':'))
      
      Bridged.htmlunit = Rjb::import('org.openqa.selenium.htmlunit.HtmlUnitDriver')
      Bridged.firefox = Rjb::import('org.openqa.selenium.firefox.FirefoxDriver')
      Bridged.rendered_web_element = Rjb::import('org.openqa.selenium.RenderedWebElement')
      
      if Bridged.htmlunit.nil?
        raise ConfigurationError.new('The htmlunit Java library could not be loaded!') 
      end
      
      self.loaded = true
      
    end
  end
  
  Driver = Backseat::Wrappers::DriverWrapper
  
end