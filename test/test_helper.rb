require 'bundler/setup'
require 'minitest/autorun'

if ENV['TRAVIS'] == 'true'
  require 'coveralls'
  Coveralls.wear!
end

require 'vcr'

require_relative '../lib/filmbuff'
