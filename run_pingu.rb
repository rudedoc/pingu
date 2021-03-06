require File.join(File.dirname(__FILE__), 'lib/pingu')

require 'ostruct'
require 'yaml'

data = YAML.load_file('config.yml')['routers']

routers = data.collect { |router| OpenStruct.new(router[1]) }

Process.detach(
  fork {
    Signal.trap('HUP', 'IGNORE') # Don't die upon logout
    Pingu::RoutersClient.new(routers).call_routers }
)