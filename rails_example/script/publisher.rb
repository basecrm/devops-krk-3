#!/usr/bin/env ruby
# encoding: utf-8

require "rubygems"
require "bunny"

host = ENV.fetch('MQ_1_PORT_5672_TCP_ADDR', 'localhost')
port = ENV.fetch('MQ_1_PORT_5672_TCP_PORT', 5672)


conn = Bunny.new(:host => host, :port => port)
conn.start

ch = conn.create_channel
x  = ch.fanout("test.queue")
x.publish("Hello!")

sleep 1.0
conn.close
