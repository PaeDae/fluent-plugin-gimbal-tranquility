require 'bundler/setup'
require 'fluent/output'

module Fluent
  module Tranquility
    autoload :PusherFactory, File.expand_path('../tranquility/pusher_factory', __FILE__)
    autoload :Pusher,        File.expand_path('../tranquility/pusher', __FILE__)
    autoload :Handler,       File.expand_path('../tranquility/handler', __FILE__)
    autoload :Formatter,     File.expand_path('../tranquility/formatter', __FILE__)

    require File.expand_path('../tranquility/plugin', __FILE__)
    Fluent::Plugin.register_output('tranquility', Plugin)
  end
end
