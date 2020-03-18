#!/usr/bin/env ruby

require 'net/ssh'
load 'modules/options.rb'

class Tail 

  include OptionsModule

  def initialize

    Options.new

    @fd = file_descriptor(Options::OPTIONS.filename)

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
        p line
      end
    end
  end

end

file = Tail.new
file.tail(file)
