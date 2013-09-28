require 'spec_helper'
require 'yaml'
require 'ostruct'

data = YAML.load_file('config.yml')['routers']

routers = data.collect { |router| OpenStruct.new(router[1]) }

Pingu::RoutersClient.new(routers).call_routers