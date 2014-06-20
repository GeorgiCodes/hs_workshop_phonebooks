#!/usr/bin/env ruby

require 'optparse'
require 'pp'

# options = {}
#
# parser = OptionParser.new do |opts|
#   opts.on("-create") do |file_name|
#     options[:file_name] = file_name
#     puts options
#   end
#
#   opts.on("-add") do |values|
#     puts "asdlfkjasdl;flaksdjf"
#
#     values.shift
#     puts "Values are #{values}"
#     # if (values.length < 3)
#     #   raise "Incorrect number of arguments."
#     # end
#
#     # TODO: check types of values
#     entry = {}
#     entry[:file_name] = values[-1]
#     entry[:name] = values.first
#     entry[:number] = values[1]
#     puts entry
#
#     add(entry)
#
#   end
# end

class Person
  attr_accessor :name, :number

  def initialize(name, number)
    @name = name
    @number = number
  end

  def to_s
    @name + ", " + @number
  end
end

class Phonebook

  def initialize(file_name)
    @entries = {}
    @file_name = file_name
    read_file_into_hash()
  end

  def add(options)
    person = add_person_to_hash(options[:name], options[:number])
    add_person_to_phonebook_file(person)
  end

  def lookup(name)
    puts "Phonebook entries for name #{name} are: "
    @entries.each do |key, value|
      if(key.include? name)
        puts value.to_s
      end
    end
  end

  def read_file_into_hash()
    # begin
      file_contents = File.open("./" + @file_name)
      file_contents.each do |line|
        values = line.split(",").map(&:strip)
        @entries[values.first] = Person.new(values.first, values.last)
      end
      puts @entries
    #
    #   puts "files_contents are #{@entries}"
    # rescue
    #   puts Dir.pwd
    #   puts "Phonebook file #{file_name} doesn't exist, you must create it first."
    # end
  end

  def add_person_to_phonebook_file(person)
    open(@file_name, 'a') do |file|
      file.puts person.to_s
    end
  end

  def add_person_to_hash(name, number)
    person = Person.new(name, number)

    # TODO: This feature is not working
    if (@entries.has_value?(person))
      raise "Duplicate entry, person is already in phonebook"
    end

    @entries[name] = person
    puts "Added person to hash #{@entries}"
    return person
  end

end

def init_options
  case ARGV[0]
    when "lookup"
      values = ARGV[1..-1]
      puts "Arguments are #{values}"

      if (values.length < 2)
        raise "Incorrect number of arguments."
      end

      phonebook = Phonebook.new(values[-1])
      phonebook.lookup(values.first)

    when "add"
      values = ARGV[1..-1]
      puts "Arguments are #{values}"

      if (values.length < 3)
        raise "Incorrect number of arguments."
      end

      entry = {}
      entry[:name] = values.first
      entry[:number] = values[1]

      phonebook = Phonebook.new(values[-1])
      phonebook.add(entry)
  end
end
init_options

# Parase and print options

# Parse the command-line. Remember there are two forms
# of the parse method. The 'parse' method simply parses
# ARGV, while the 'parse!' method parses ARGV and removes
# any options found there, as well as any parameters for
# the options. What's left is the list of files to resize
# parser.parse!
# pp "Options:", options
# pp "ARGV:", ARGV

