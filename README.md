<h3 align="center">Smee Client (Ruby)</h3>
<p align="center">A programmatic client for <a href="https://smee.io">Smee</a>, in Ruby.<p>

## Usage

### Installation

```sh
$ gem install smee
```

```ruby
client = SmeeClient.new(
  source: 'https://smee.io/<channel>',
  target: 'http://localhost:3000/'
)

client.start
```

Now when events come in, they'll be automatically `POST`-ed to the configured target URL.