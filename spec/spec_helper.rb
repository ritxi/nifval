require 'simplecov'
require 'simplecov-cobertura'

SimpleCov.start do
  add_filter '/spec/'
  add_group 'Libraries', 'lib'
end

if ENV['CI']
  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'nifval'
require 'rspec'
