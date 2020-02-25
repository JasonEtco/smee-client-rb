# frozen_string_literal: true

require './lib/smee'

client = SmeeClient.new(
  'https://smee.io/jasons-testing-url',
  'http://localhost:3000/'
)

client.start
