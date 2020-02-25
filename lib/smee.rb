# frozen_string_literal: true

require 'ld-eventsource'

# The main Smee client class
class SmeeClient
  def initialize (source, target)
    @source = source
    @target = target
  end

  def start
    @events = SSE::Client.new(@source) do |client|
      client.on_event do |event|
        puts "I received an event: #{event.type}, #{event.data}"
      end
    end
  end
end
