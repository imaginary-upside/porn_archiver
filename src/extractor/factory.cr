require "./reddit"
require "./imgur"

module PornArchiver::Extractor
  extend self

  def factory(link : String,
              user : String? = nil,
              parent_extractor : String? = nil) : Base?
      case link
      when .includes?("reddit.com"),
           .includes?("i.redd.it")
        Reddit.new URI.parse(link), user, parent_extractor
      when .includes?("imgur.com")
        Imgur.new URI.parse(link), user, parent_extractor
      end
    end  
end
