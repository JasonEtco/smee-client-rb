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

    body = json['body'].to_json
    query = URI.encode_www_form(json['query'])
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
    # Clone our target so we can append fresh query params
    target = @target.clone
    target.query = query

    # Setup the HTTP request
    http = Net::HTTP.new(target.host, target.port)
    request = Net::HTTP::Post.new(target.request_uri, headers)

    # Attach the body
    request.body = body

    # Make the POST request
    res = http.request(request)
    puts "[SmeeClient]: Pushed event, response: #{res.body}"
  end
end
