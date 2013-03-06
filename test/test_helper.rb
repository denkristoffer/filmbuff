require 'bundler/setup'
require 'minitest/autorun'
require 'simplecov'
SimpleCov.start do
  add_filter '/vendor/bundle'
end
require 'vcr'

require_relative '../lib/filmbuff'
