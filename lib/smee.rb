# frozen_string_literal: true

require 'ld-eventsource'

# The main Smee client class
class SmeeClient
  def initialize(source, target)
    @source = source
    @target = target
  end

  def start
    puts 'Starting SmeeClient'

    # Why doesn't this stay open?
    SSE::Client.new(@source) do |client|
      client.on_event do |event|
        puts 'EVENT'
      end
    end
  end
end
