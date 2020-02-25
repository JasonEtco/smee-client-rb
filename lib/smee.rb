# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'
require 'ld-eventsource'

# The main Smee client class
class SmeeClient
  def initialize(source:, target:)
    @source = source
    @target = URI.parse(target)
  end

  def start
    puts "[SmeeClient]: Listening for events at #{@source}"
    subscribe
  end

  def close
    @events.close
  end

  private

  def subscribe
    @events = SSE::Client.new(@source) do |client|
      client.on_event do |event|
        handle_event event
      end

      client.on_error do |error|
        puts "Error: #{error}"
      end
    end
  end

  def handle_event(event)
    json = JSON.parse event.data
    return unless json.key?('body')

    post(json['body'].to_json)
  end

  def post(body)
    # Setup the HTTP request
    http = Net::HTTP.new(@target.host, @target.port)
    header = { 'Content-Type': 'application/json' }
    request = Net::HTTP::Post.new(@target.request_uri, header)

    # Attach the body
    request.body = body

    # Make the POST request
    res = http.request(request)
    puts "[SmeeClient]: Pushed event, response: #{res.body}"
  end
end
