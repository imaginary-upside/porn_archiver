require "./extractor/factory"
require "uri"

module PornArchiver
  VERSION = "0.1.0"

  r = Extractor.factory ARGV[0]
  r.start if r
end
