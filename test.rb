# frozen_string_literal: true

require './lib/smee'

client = SmeeClient.new(
  source: 'https://smee.io/jasons-testing-url',
  target: 'http://localhost:3000/'
)

client.start
