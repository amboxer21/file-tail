#!/usr/bin/env ruby

class Tail

  def initialize(filename)
    @fd = file_descriptor(filename)
  end

  def file_descriptor(filename)
    ofd = IO.sysopen(filename, 'r')
    fd  = IO.new(ofd)
    fd.seek(-1, IO::SEEK_END)
    return fd
  end

  def poll(bufflen=4096)
    begin 
      @fd.read_nonblock(bufflen)
    rescue IO::WaitReadable, IO::EAGAINWaitReadable
      IO.select([@fd])
      retry
    rescue EOFError
      sleep 0.2
      retry
    end
  end

  def tail(data)
    while true do
      for line in [data.poll] do
        puts line
      end
    end
  end

end

@_filename = ARGV[0]
file = Tail.new @_filename
file.tail(file)
