# frozen_string_literal: true

require 'json'
require 'ld-eventsource'
require 'httparty'

# The main Smee client class
class SmeeClient
  def self.create_channel
    response = HTTParty.head('https://smee.io/new', follow_redirects: false)
    response.headers['location']
  end

  def initialize(source:, target:)
    @source = source
    @target = URI.parse(target)
  end

  def start
    puts "[SmeeClient]: Listening for events at #{@source}"
    subscribe
  end

  def close
    puts '[SmeeClient]: Closing connection'
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

    body = json['body']
    query = json['query']

    headers = copy_headers(json)

    post(body, query, headers)
  end

  def copy_headers(json)
    headers = {
      'Content-Type': 'application/json'
    }

    # Don't want to include these as headers
    json.delete 'body'
    json.delete 'query'

    json.each do |key, value|
      # We need to ensure that headers are strings
      headers[key] = value.to_s
    end

    headers
  end

  def post(body, query, headers)
    # Send an HTTP request
    response = HTTParty.post(@target, {
      query: query,
      body: body.to_json,
      headers: headers
    })

    puts "[SmeeClient]: Pushed event, response: #{response.body}"
  end
end
