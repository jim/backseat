require 'rubygems'
require 'spec'
require 'backseat'
include Backseat

describe 'a simple test' do
  before(:all) do
    Backseat.load!
    @driver = Backseat::Driver.new(:firefox)
  end
  
  it "should do some basic navigation" do
    @driver.get('http://localhost:3000/products')
    @driver.should have_at_least(2).elements(div(:class => 'album_product'))
    
    @driver[h2.a].click
    
    @driver.should have(1).elements(ol(:class => 'track_list'))
    @driver[ol(:class => 'track_list')].should have(4).elements(li)
  end
  
  after(:all) do
    @driver.close
  end
end
