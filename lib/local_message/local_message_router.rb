require 'socket'

class LocalMessageRouter

  attr_reader :port, :registered_users, :open_ports

  def initialize(listening_port)
    @port = listening_port
    @registered_users = {}
  end

  def start
    server = TCPServer.open(port)
    begin

      Thread.start(server.accept) do |client|
        fam, port, hostname, ip = client.peeraddr
        message = client.read
        handle(message, port, ip)
        client.close
      end

    end while true
  end

  def handle(message, port, ip)
    if register?(message)
      username, port = strip_username_port(message)
      register(username, port.to_i, ip)

    elsif has_recipient?(message)
      recipient = strip_recipient(message)
      sender = username_by_ip(ip)
      forward_message(sender, recipient, message)
    end
  end

  def register?(message)
    return true if /^@register/.match(message)
    false
  end

  def registered?(username)
    registered_users.has_key?(username)
  end

  def register(username, port, ip)
    registered_users[username] = LocalMessageUser.new(port, ip)
  end

  def username_by_ip(ip)
    registered_users.values.each do |user|
      return registered_users.key(user) if user.hostname == ip
    end
  end

  def strip_username_port(message)
    /@register\s+(.+)\s+(\d+)/.match(message)
    [$1, $2]
  end

  def has_recipient?(message)
    return true if /(@.+)\s+/.match(message)
    false
  end

  def strip_recipient(message)
    message.split[0].slice(1..-1)
  end

  def strip_message(message)
    message.split(" ", 2)[1]
  end

  def forward_message(sender, recipient, message)
    if registered?(recipient)
      info = registered_users[recipient]
      message_with_sender = "@#{sender} #{strip_message(message)}"
      send(info.hostname, info.port, message_with_sender)
    end
  end

  def send(hostname, port, message)
    Thread.new do
      socket = TCPSocket.open(hostname, port)
      socket.write(message)
      socket.close
    end
  end

end