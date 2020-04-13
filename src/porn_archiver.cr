require "./extractor/factory"
require "uri"
require "option_parser"

module PornArchiver
  VERSION = "0.1.0"

  base = "archive"

  OptionParser.parse do |parser|
    parser.banner = "Usage: porn_archiver [arguments] url1 url2 ..."
    
    parser.on("-o OUT", "--out=OUT", "Base directory to store archives") do |v|
      base = v
    end
    parser.on("-h", "--help", "Show this help") { puts parser }
  end

  ARGV.each do |url|
    r = Extractor.factory url
    r.start if r
  end
end
