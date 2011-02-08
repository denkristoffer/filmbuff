# encoding: utf-8
$:.push File.expand_path("../filmbuff", __FILE__)
require "imdb"
require "feature"

module Filmbuff
  class IMDbInvalidArgument < StandardError; end
  class IMDbInvalidLocale < StandardError; end
  class IMDbInvalidURL < StandardError; end
  class IMDbRequestError < StandardError; end
  class IMDbValidationError < StandardError; end

  public
  def self.search(query, locale = nil)
    imdb = IMDb.new
    imdb.locale = locale unless locale.nil?
    arguments = {
      "q" => query
    }

    imdb.request("/find", arguments)
  end
end
