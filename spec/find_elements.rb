require 'rubygems'
require 'spec'
require 'backseat'
include Backseat

def path_to_html(file)
  # TODO make this method safe for windows
  html_path = File.join(File.dirname(File.expand_path(__FILE__)), 'html')
  "file://#{html_path}/#{file}"
end

describe 'Finding Elements' do
  before(:all) do
    Backseat.load!('/Users/jimb/src/webdriver/trunk')
    @driver = Backseat::Driver.new(:firefox)
    @driver.get(path_to_html('find_elements.html'))
  end
  
  it "should find elements by tag name" do
    @driver.should have(3).elements(input)    
  end
  
  it "should find elements by tag name with attributes specified" do
    @driver.should have(1).elements(input(:type => 'submit'))
  end
  
  it "should find elements using shortcut bracket" do
    @driver[p(:class => 'first')].should have(1).elements(input)
  end
  
  it "should find elements using descendant tag methods" do
    @driver[p(:class => 'second').input][:id].should eql('input_2')
  end
  
  it "should read attributes using shortcut brackets" do
    @driver[p(:class => 'second').input][:id].should eql('input_2')
  end
  
  after(:all) do
    @driver.close
  end
end
