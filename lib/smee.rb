# frozen_string_literal: true

require 'ld-eventsource'

# The main Smee client class
class SmeeClient
  def initialize(source:, target:)
    @source = source
    @target = target
  end

  def subscribe
    SSE::Client.new(@source) do |client|
      client.on_event do |event|
        puts "Event: #{event.type}, #{event.data}"
      end

      client.on_error do |error|
        puts "Error: #{error}"
      end
    end
  end

  def start
    puts 'Starting SmeeClient'
    subscribe
  end
end
