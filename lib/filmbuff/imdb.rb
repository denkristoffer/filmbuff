# encoding: utf-8
require "json"
require "net/http"
require "openssl"

module Filmbuff
  class IMDb
    attr_reader :locale

    def initialize
      @api = "v1"
      @api_key = "2wex6aeu6a8q9e49k7sfvufd6rhh0n"
      @api_policy = "app1_1"
      @app_id = "iphone1_1"
      # @digest will be used to sign our requests
      @digest = OpenSSL::Digest::Digest.new('sha1')
      # Device doesn't matter. Set it to 40 random alphanumeric characters
      @device = (1..40).collect do
        (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr
      end.join
      @locale = "en_US"
    end

    public
    def locale=(locale = nil)
      locales = %w{de_DE en_US es_ES fr_FR it_IT pt_PT}

      if locales.include? locale
        @locale = locale
      else
        raise IMDbInvalidLocale, "Unknown locale. Only the following are " << 
          "allowed:\n" << locales.join(", ")
      end
    end

    def request(function, hash)
      arguments = create_arguments(hash)
      url = create_url(function, arguments)
      data = Net::HTTP.get_response(URI.parse(url)).body
      unless result = JSON.parse(data)
        raise IMDbRequestError, "Request could not be completed"
      else
        return result
      end
    end

    private
    def create_arguments(hash)
      unless hash.is_a? Hash
        raise IMDbInvalidArgument, "Argument must be a hash"
      end

      arguments = {
        "api" => @api,
        "app_id" => @app_id,
        "device" => @device,
        "locale" => @locale,
        "timestamp" => Time.now.utc.to_i,
        "sig" => @api_policy
      }
      hash.merge!(arguments)
    end

    def create_url(function, hash)
      arguments = hash.map do |key, value|
        value.to_s.gsub!(/ /, "+")
        "#{key.to_s}=#{value.to_s}"
      end.join("&")

      url = "http://app.imdb.com#{function}?#{arguments}"
      url << "-#{OpenSSL::HMAC.hexdigest(@digest, @api_key, url)}"
    end
  end
end
