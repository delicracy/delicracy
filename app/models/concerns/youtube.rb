module Youtube
  def self.build(url)
    uri = URI.parse(url)
    case uri.host
    when DefaultHost.host_pattern then DefaultHost.new(uri)
    when ShortenHost.host_pattern then ShortenHost.new(uri)
    end
  end

  def self.valid?(url)
    DefaultHost.validation_pattern.match?(url) or ShortenHost.validation_pattern.match?(url)
  end
end

class DefaultHost
  attr_reader :uri, :type

  def self.host_pattern
   /(www\.)*youtube\.com/ 
  end

  def self.validation_pattern
    Regexp.new(self.host_pattern.source + '\/watch\?.+')
  end

  def initialize(uri)
    @type = :default
    @uri = uri
  end

  def id
    URI.decode_www_form(uri.query).to_h['v']
  end
end

class ShortenHost
  attr_reader :uri, :type

  def self.host_pattern
    /youtu\.be/
  end

  def self.validation_pattern
    Regexp.new(self.host_pattern.source + '\/.+')
  end

  def initialize(uri)
    @type = :shorten
    @uri = uri
  end

  def id
    uri.path.slice(%r{[^/]+})
  end
end
