require "file_utils"
require "http/client"
require "json"
require "uri"
require "file"

module PornArchiver::Api
  class Reddit
    COMMENT_TYPE   = "t1"
    ACCOUNT_TYPE   = "t2"
    LINK_TYPE      = "t3"
    MESSAGE_TYPE   = "t4"
    SUBREDDIT_TYPE = "t5"
    AWARD_TYPE     = "t6"

    def initialize
      client = HTTP::Client.new "www.reddit.com", tls: true
      client.basic_auth "NZ66a_0lFfZbIg", ""
      r = client.post "/api/v1/access_token", form: {
        "grant_type" => "https://oauth.reddit.com/grants/installed_client",
        "device_id" => "DO_NOT_TRACK_THIS_DEVICE"
      }

      @client = HTTP::Client.new "oauth.reddit.com", tls: true
      @client.before_request do |req|
        req.headers["Authorization"] = "Bearer #{JSON.parse(r.body)["access_token"]}"  
      end
    end

    def get_submitted(username : String)
      offset = ""

      loop do
        params = HTTP::Params.encode({
          "after" => offset,
          "limit" => "100"
        })
        r = @client.get "/user/#{username}/submitted?#{params}"
        data = JSON.parse r.body

        posts = data["data"]["children"].as_a
        posts.each { |post| yield post }

        break unless posts.size == 100

        offset = posts[-1]["data"]["name"].to_s
      end
    end
  end
end
