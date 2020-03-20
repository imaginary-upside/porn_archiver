require "http/client"

module PornArchiver::Api
  class Imgur
    def initialize
      @client = HTTP::Client.new "api.imgur.com", tls: true
      @client.before_request do |req|
        req.headers["Authorization"] = "Client-ID 50a8c332295547a"
      end
    end
  end
end
