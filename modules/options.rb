require 'ostruct'
require 'optparse'

module OptionsModule
  class Options

    OPTIONS = OpenStruct.new

    def initialize

      OptionParser.new do |opt|
        opt.on("--help", TrueClass) do |help|
          OPTIONS.help = help
        end
        opt.on('-fFILENAME', '--filename FILENAME', String) do |filename|
          OPTIONS.filename = filename
        end
      end.parse!
      
      usage if OPTIONS.filename.nil? 

    end

    def usage(message=nil)

      puts "\n    ** #{message} ** \n" unless message.nil? or message.empty?
    
      puts "\n\n    Usage: #{$PROGRAM_NAME} --file-name=FILENAME or -fFILENAME\n\n"
      puts "    Option:\n        --help,            Display this help messgage.\n\n"
      puts "    Option:\n        --filename, -f,    File for the program to tail.\n"
      exit
    end

  end
end
