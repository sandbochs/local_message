class LocalMessageUser

  attr_reader :port, :hostname

  def initialize(port_number, host_name)
    @port = port_number
    @hostname = host_name
  end

  def ==(other)
    hostname == other.hostname
  end

  def eql?(other)
    self == other
  end

  def hash
    hostname.hash
  end

end