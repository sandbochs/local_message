#!/usr/bin/env ruby
require '../lib/local_message/local_message_client'

sent_message = true
recv_message = true
print "Please enter your username >> "
username = gets.chomp

lmclient = LocalMessageClient.new('localhost', '5500', username)
lmclient.register

while true

  if recv_message == true
    recv_message = false
    Thread.new do
      inc_msg = lmclient.listen
      puts "\nIncoming message >> #{inc_msg}"
      recv_message = true
      print "Enter message ( @username hello world )>> "
    end
  end

  if sent_message == true
    sent_message = false
    Thread.new do
      print "Enter message ( @username hello world )>> "
      message = gets.chomp
      lmclient.send(message)
      sent_message = true
    end
  end

end