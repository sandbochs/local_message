## LocalMessage [![Build Status](https://secure.travis-ci.org/sandbochs/local_message.png?branch=master)](https://travis-ci.org/sandbochs/local_message)

A Ruby Gem for sending messages as strings across a local network. (UDP style no handshake or acknowledgements)

This was spawned after encountering limitations during a group project at Dev Bootcamp. We had to write a Connect Four clone and play over Twitter. With multiple groups hammering the Twitter API simultaneously we were eventually cut off from the API altogether. Not a single Connect Four game was completed =(.

## Todo

- Markup with Rdoc
- Add messaging list functionality to send messages to multiple users
- Add a command to list all registered usernames & messaging lists
- Add exception handling to the router
- Add ability to turn console logging on or off for router

## Usage

LocalMessageRouter => Maps usernames to ip addresses and a randomly generated port in order to route multiple simultaneous messages across a local network.

```ruby
router = LocalMessageRouter.new(5000)
```

Start the router on port 5000

```ruby
router.start
```

LocalMessageClient => Interacts with the LocalMessageRouter. Takes the server hostname/ip, listening port, and client username as arguments.

```ruby
client = LocalMessageClient.new('localhost', 5000, 'sandbochs')
```

Registers username with the LocalMessageRouter.

```ruby
client.register
```

Send a message, 'hello world' to the user, foobar.
foobar's client.listen will return '@sandbochs hello world'

```ruby
client.send_message("@foobar hello world")
```

Wait for a message from the server, returns a string

```ruby
client.listen
```
