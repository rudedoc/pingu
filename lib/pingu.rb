#require "pingu/version"

module Pingu
  class RoutersClient
    attr_reader :routers
    require 'open-uri'
    require 'yaml'

    def initialize(router_array)
      puts router_array.inspect
      @routers = router_array.cycle
    end

    def call_routers
      current_router = routers.next
      sleep(5)
      call_routers if call_to(current_router) == ["200", "OK"]
    rescue
      send_text(current_router)
      sleep(60)
    ensure
      call_routers
    end

    private

    def call_to(router)
      io = open('http://'+ router.ip + '/weblogin.htm')
      size = `ps ax -o pid,rss | grep -E "^[[:space:]]*#{$$}"`.strip.split.map(&:to_i)[1]
      puts router.ip + " " + io.status.inspect + " " + Time.now.to_s + " " + size.to_s
      io.status
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
        puts requested_url
        open(requested_url)
      end
      sleep(60)
    end
  end
end
