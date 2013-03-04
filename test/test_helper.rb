require 'bundler/setup'
require 'minitest/autorun'
require 'simplecov'
SimpleCov.start do
  add_filter '/vendor/bundle'
end

require_relative '../lib/filmbuff'
