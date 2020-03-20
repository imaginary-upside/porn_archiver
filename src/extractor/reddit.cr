require "./base"
require "./factory"
require "../api/reddit"

module PornArchiver::Extractor
  class Reddit < Base
    @@client = Api::Reddit.new

    def initialize(url : URI,
                   user : String? = nil,
                   parent_extractor : String? = nil)
      unless user
        if match = /\/user\/(\w+)$/.match(url.to_s)
          user = match[1]
        end
      end

      parent_extractor ||= "reddit"

      super
    end

    def start
      return if super

      if @url.to_s.includes? "/user/"
        return unless @user

        @@client.get_submitted(@user.to_s) do |post|
          next unless post["kind"].to_s == Api::Reddit::LINK_TYPE
          f = Extractor.factory(
            post["data"]["url"].to_s,
            @user,
            @parent_extractor
          )
          next unless f
          f.start
        end
      end
    end
  end
end
