require "uri"
require "file_utils"
require "time"

module PornArchiver::Extractor
  abstract class Base
    abstract def start
    
    def initialize(@url : URI,
                   @user : String? = nil,
                   @parent_extractor : String? = nil)
      @user ||= "generic"
    end

    def start
      if @url.to_s =~ /\.png|\.jpg/
        download_image(@url, "archive/#{@user}/#{@parent_extractor}")
      end
    end

    def download_image(image : URI, path : String)
      FileUtils.mkdir_p(path)

      dest = path + image.path
      return if File.exists? dest

      HTTP::Client.get(image) do |r|
        return unless r.success?

        File.write(dest, r.body_io)

        if lm = r.headers["last-modified"]?
          t = Time.parse(lm, "%a, %d %b %Y %T", Time::Location::UTC)
          FileUtils.touch(dest, t)
        end
      end
    end
  end
end
