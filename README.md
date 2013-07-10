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

To get started quickly, you should use Betterific::JsonClient, which uses JSON
as its data format and requires no extra gems besides the json gem, which is
likely already installed on your machine.

### Betterifs

You can see the most popular betterifs of the last week using

    Betterific::JsonClient.betterifs(:most_popular)

A similar call can be used to see the most recent betterifs

    Betterific::JsonClient.betterifs(:most_recent)

If you already know the id(s) of the betterif(s) that you would like to see,
you can use

    Betterific::JsonClient.betterifs(:ids => [id0, id1, ...])

### Tags and Users

You can see a list of tags or users by id using

    Betterific::JsonClient.tags(:ids => [id0, id1, ...])

and

    Betterific::JsonClient.users(:ids => [id0, id1, ...])

### Search

You can search for betterifs, tags, users, or all of these using

    Betterific::JsonClient.search(:namespace => :all, :q => 'my query')

Changing the :namespace parameter will change the type of data returned.

### Using Protocol Buffers

If you have
[ruby-protocol-buffers](https://github.com/codekitchen/ruby-protocol-buffers)
installed, you can use Betterific::ProtobufClient in place of
Betterific::JsonClient. This will greatly improve performance, as
[Protocol Buffers](https://developers.google.com/protocol-buffers/) are highly
optimized.

The Betterific::ProtobufClient responds to the same methods as the
Betterific::JsonClient, so it's easy to exchange one for the other at will. Just
don't forget that while JSON uses access methods like

    my_json['key']

the [ruby-protocol-buffers](https://github.com/codekitchen/ruby-protocol-buffers)
has its own auto-generated classes that create methods like

    my_protobuf_instance.key

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
