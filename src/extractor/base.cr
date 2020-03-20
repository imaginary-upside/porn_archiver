require "uri"

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
        File.write(dest, r.body_io)
      end
    end
  end
end
