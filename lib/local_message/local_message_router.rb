require 'socket'

class LocalMessageRouter

  attr_reader :port, :registered_users, :open_ports

  def initialize(listening_port)
    @port = listening_port
    @registered_users = {}
    @open_ports = []
  end

  def start
    server = TCPServer.open(port)
    begin

      puts "Listening on port: #{port}..."
      Thread.start(server.accept) do |client|
        fam, port, hostname, ip = client.peeraddr
        puts "Connection initiated from #{hostname}:#{port}"
        message = client.read
        puts "Message from #{hostname}:#{port}: #{message}"
        puts handle(message, port, ip)
        puts "Closing connection from #{hostname}:#{port}"
        client.close
      end

    end while true
  end

  def handle(message, port, ip)
    if register?(message)
      username, port = strip_username_port(message)
      register(username, port.to_i, ip)
      if registered?(username)
        puts "Registered #{username} => #{ip}:#{port}"
      else
        puts "Couldn't register #{username}"
      end
      #send_register_ack(ip, port, username)
    elsif has_recipient?(message)
      recipient = strip_recipient(message)
      sender = username_by_ip(ip)
      forward_message(sender, recipient, message)
      if registered?(recipient)
        #send_ack(ip, port, recipient, message)
      else
        #send_ack(ip, port, recipient, "No such recipient")
      end
    else
      "Message not handled"
    end
  end

  def register?(message)
    return true if /@register/.match(message)
    false
  end

  def registered?(username)
    registered_users.has_key?(username)
  end

  def register(username, port, ip)
    registered_users[username] = LocalMessageUser.new(port, ip)
  end

  def send_register_ack(hostname, port, username)
    if registered?(username)
      send(hostname, port, "Successfully registered #{username}")
      "Successfully registered #{username}"
    else
      send(hostname, port, "Failed to register #{username}")
      "Failed to register #{username}"
    end
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
    message.split[1..-1].join(" ")
  end

  def forward_message(sender, recipient, message)
    if registered?(recipient)
      info = registered_users[recipient]
      message_with_sender = "@#{sender} #{strip_message(message)}"
      puts "Sending message to #{recipient}, host: #{info.hostname} port: #{info.port}"
      send(info.hostname, info.port, message_with_sender)
    end
  end

  def port_open?(port)
    open_ports.include?(port)
  end

  def send(hostname, port, message)
    Thread.new do
      puts "Sending #{message} to #{hostname}:#{port}"
      socket = TCPSocket.open(hostname, port)
      sleep 1
      socket.write(message)
      socket.close
    end
  end

  def send_ack(hostname, port, recipient, message)
    send(hostname, port, "Sent #{message} to #{recipient}")
    "Sent #{message} to #{hostname}:#{port}"
  end

end