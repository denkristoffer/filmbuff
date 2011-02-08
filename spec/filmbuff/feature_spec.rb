# encoding: utf-8
$:.push File.expand_path("../../../lib", __FILE__)
require "filmbuff"

describe Filmbuff::Feature do
  before :all do
    @imdb = Filmbuff::Feature.new
  end
end
