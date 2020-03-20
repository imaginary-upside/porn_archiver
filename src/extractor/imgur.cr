require "./base"
require "../api/imgur"

module PornArchiver::Extractor
  class Imgur < Base
    @@client = Api::Imgur.new

    def initialize(url : URI,
                   user : String? = nil,
                   parent_extractor : String? = nil)
      parent_extractor ||= "imgur"

      super
    end

    def start
      case @url.to_s
      when .includes?(".png"),
           .includes?(".jpg")
        download_image(@url, "archive/#{@user}/#{@parent_extractor}")
      end
    end
  end
end
