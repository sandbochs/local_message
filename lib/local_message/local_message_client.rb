require 'socket'

class LocalMessageClient

  attr_reader :server, :port, :username, :listen_port

  def initialize(server_hostname, server_port, user_name)
    @server = server_hostname
    @port = server_port
    @username = user_name
    @listen_port = Random.rand(2000..30_000)
  end

  def register
    send_message("@register #{username} #{listen_port}")
  end

  def send_message(message)
    socket = TCPSocket.open(server, port)
    socket.write(message)
    socket.close
  end

  def listen
    server = TCPServer.open(listen_port)
    client = server.accept
    message = client.read
    client.close
    server.close
    message
  end

end