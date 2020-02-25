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
    puts 'Starting SmeeClient'
    subscribe
  end

  private

  def subscribe
    SSE::Client.new(@source) do |client|
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
    puts body

    header = { 'Content-Type': 'application/json' }
    http = Net::HTTP.new(@target.host, @target.port)
    request = Net::HTTP::Post.new(@target.request_uri, header)
    request.body = body
    res = http.request(request)

    puts res.body
  end
end
