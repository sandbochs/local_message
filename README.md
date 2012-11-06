### local_message #####

A Ruby Gem for sending messages across a local network.

This was spawned after encountering limitations during a group project at Dev Bootcamp. We had to write a Connect Four clone and play over Twitter. With multiple groups hammering the Twitter API simultaneously we were eventually cut off from the API altogether.

### Usage #####

LocalMessageRouter - Maps usernames to ip addresses and  ports to route multiple simultaneous messages across a local network.

- start(port_number) - Starts the router on specified port.

LocalMessageClient - Interacts with the LocalMessageRouter.

- register - Registers a username with the LocalMessageRouter.
- send - Sends a message to the server.
- listen - Waits for a message from the server.

LocalMessageUser - Stores ip address and port for a specific username.