module Backseat::Server
  
  # This file snatched from Webrat for the time being
  # Copyright © 2007-2008 Bryan Helmkamp, Seth Fitzsimmons.
  # http://github.com/brynary/webrat/tree/master
  
  def self.configure(configuration = Backseat::Server.configuration)
    yield configuration if block_given?
    @@configuration = configuration
  end
 
  def self.configuration
    @@configuration ||= Backseat::Server::Configuration.new
  end
  
  class Configuration
    # What framework are we using
    attr_accessor :framework
    
    # Port to launch server on
    attr_accessor :port
    
    # Environment to launch the app in
    attr_accessor :environment
    
    # Address of server
    attr_accessor :address
    
    def initialize
      self.framework = :rails
      self.port = 8888
      self.environment = :test
    end
  end
  
  def self.pid_file
    if File.exists?('config.ru')
      prepare_pid_file(Dir.pwd, 'rack.pid')
    else
      prepare_pid_file("#{RAILS_ROOT}/tmp/pids", "mongrel_backseat.pid")
    end
  end
  
  def self.prepare_pid_file(file_path, pid_file_name)
    FileUtils.mkdir_p File.expand_path(file_path)
    File.expand_path("#{file_path}/#{pid_file_name}")
  end
  
  def self.start
    case Backseat::Server.configuration.framework
    when :sinatra
      fork do
        File.open('rack.pid', 'w') { |fp| fp.write Process.pid }
        exec 'rackup', File.expand_path(Dir.pwd + '/config.ru'), '-p', Backseat::Server.configuration.port.to_s
      end
    when :merb
      cmd = 'merb'
      if File.exist?('bin/merb')
        cmd = 'bin/merb'
      end
      system("#{cmd} -d -p #{Backseat::Server.configuration.port} -e #{Backseat::Server.configuration.environment}")
    else # rails
      system("mongrel_rails start -d --chdir='#{RAILS_ROOT}' --port=#{Backseat::Server.configuration.port} --environment=#{Backseat::Server.configuration.environment} --pid #{pid_file} &")
    end
    self.wait_for_service :host => Backseat::Server.configuration.address, :port => Backseat::Server.configuration.port.to_i
  end
 
  # Stop the appserver for the underlying framework under test
  #
  # Sinatra: Reads and kills the pid from the pid file created on startup
  # Merb: Reads and kills the pid from the pid file created on startup
  # Rails: Calls mongrel_rails stop to kill the appserver
  def self.stop
    case Backseat::Server.configuration.framework
    when :sinatra
      pid = File.read('rack.pid')
      system("kill -9 #{pid}")
      FileUtils.rm_f 'rack.pid'
    when :merb
      pid = File.read("log/merb.#{Backseat::Server.configuration.port}.pid")
      system("kill -9 #{pid}")
      FileUtils.rm_f "log/merb.#{Backseat::Server.configuration.port}.pid"
    else # rails
      system "mongrel_rails stop -c #{RAILS_ROOT} --pid #{pid_file}"
    end
  end
  
  def self.wait_for_service(options)
    socket = nil
    Timeout::timeout(options[:timeout] || 20) do
      loop do
        begin
          socket = TCPSocket.new(options[:host], options[:port])
          return
        rescue Errno::ECONNREFUSED
          puts ".\n"
          sleep 2
        end
      end
    end
  ensure
    socket.close unless socket.nil?
  end
  
end