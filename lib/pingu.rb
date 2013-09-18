require "pingu/version"

module Pingu
  class RouterClient
    attr_reader :ips
    require 'open-uri'
    require 'nokogiri'

    def initialize(ips)
      @ips = ips.cycle
    end

    def next_router
      call_to(ips.next)
    end

    def call_to(ip)
      Nokogiri::HTML(open('http://'+ ip))
    end




  end


end
