# Betterific

This gem makes it easy to access the Betterific API to explore betterifs, tags,
and users.

## Installation

Add this line to your application's Gemfile:

    gem 'betterific'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install betterific

## Usage

To get started quickly, you should use Betterific::Client, which uses
Betterific::JsonClient in the absence of the
[ruby-protocol-buffers](https://github.com/codekitchen/ruby-protocol-buffers)
gem. This will use JSON as the data format and requires no extra gems besides
the [json](http://flori.github.io/json/) gem, which is likely already installed
on your machine.

Betterific::JsonClient wraps the JSON response using
[Hashie](https://github.com/intridea/hashie), so you may access the data using
JSON object notation or via method calls. For example,

    Betterific::JsonClient.betterifs(:id => [224])['total_results']

is equivalent to

    Betterific::JsonClient.betterifs(:id => [224]).total_results

However, it is recommended that you use the latter notation since it is
compatible with Betterific::ProtobufClient, whereas the JSON object notation is
not.

### Betterifs

You can see the most popular betterifs of the last week using

    Betterific::Client.betterifs(:most_popular)

A similar call can be used to see the most recent betterifs

    Betterific::Client.betterifs(:most_recent)

If you already know the id(s) of the betterif(s) that you would like to see,
you can use

    Betterific::Client.betterifs(:ids => [id0, id1, ...])

### Tags and Users

You can see a list of tags or users by id using

    Betterific::Client.tags(:ids => [id0, id1, ...])

and

    Betterific::Client.users(:ids => [id0, id1, ...])

### Search

You can search for betterifs, tags, users, or all of these using

    Betterific::Client.search(:namespace => :all, :q => 'my query')

Changing the _:namespace_ parameter will change the type of data returned.

### Pagination

All client methods take pagination params _:page_ and *:per_page*. In the case
of most popular and most recent betterifs, the filter must be changed to a Hash
parameter, like so

    Betterific::Client.betterifs(:filter => :most_popular, :page => 2, :per_page => 10)

and

    Betterific::Client.betterifs(:filter => :most_recent, :page => 2, :per_page => 10)

### Using Protocol Buffers

If you have
[ruby-protocol-buffers](https://github.com/codekitchen/ruby-protocol-buffers)
installed, Betterific::Client will use Betterific::ProtobufClient in place of
Betterific::JsonClient. This will greatly improve performance, as
[Protocol Buffers](https://developers.google.com/protocol-buffers/) are highly
optimized.

The Betterific::ProtobufClient responds to the same methods as the
Betterific::JsonClient, so it's easy to switch between implementations at will.
For example,

    Betterific::JsonClient.users(:id => [2])

and

    Betterific::ProtobufClient.users(:id => [2])

return the same data as

    Betterific::Client.users(:id => [2])

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
