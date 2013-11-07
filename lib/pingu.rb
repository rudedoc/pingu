require File.join(File.dirname(__FILE__), 'pingu/version')

module Pingu
  class RoutersClient
    attr_reader :routers
    require 'yaml'
    require 'logger'
    require 'httparty'

    def initialize(router_array)
      @routers = router_array.cycle
      @logger = Logger.new('router_calls.log', 0, 0.5 * 1024 * 1024)
      @logger.level = Logger::WARN
      @logger.warn(@routers.inspect)
    end

    def call_routers
      current_router = routers.next
      call_routers if call_to(current_router) == 200
    rescue Net::OpenTimeout, Net::ReadTimeout, Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
      @logger.error("Could not reach router! => #{e}")
      send_text(current_router)
    ensure
      call_routers
    end

    private

    def call_to(router)
      io = HTTParty.get("http://#{router.ip}/weblogin.htm", timeout: 20.00)
      logger(router, io)
      sleep(5)
      io.code
    end

    def send_text(current_router)
      texting_configs = YAML.load_file('config.yml')['texting_configs']
      message = "http://#{current_router.ip}  #{current_router.name}  #{current_router.message}"
      numbers = texting_configs['contact_numbers'].values
      numbers.each do |number|
        requested_url =
            "https://www.txtlocal.co.uk/sendsmspost.php?" +
                "&sender=" + texting_configs['sender'] +
                "&uname=" + texting_configs['uname'] +
                "&pword=" + texting_configs['pword'] +
                "&selectednums=" + number +
                "&message=" + URI.escape(message)
        @logger.error("could not reach: #{current_router.ip}")
        HTTParty.get(requested_url)
      end
      sleep(60)
    end

    def logger(router, io)
      size = `ps ax -o pid,rss | grep -E "^[[:space:]]*#{$$}"`.strip.split.map(&:to_i)[1]
      @logger.warn(router.ip + " " + io.code.to_s + " " + Time.now.to_s + " " + size.to_s) # this should be a file write
    end
  end
end
