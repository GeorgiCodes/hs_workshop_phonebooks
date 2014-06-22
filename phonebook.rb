#!/usr/bin/env ruby

require 'optparse'
require 'pp'

class Phonebook
  attr_reader :file_name, :entries

  def self.create(file_name)
    puts "File created with name #{file_name}"
    File.write file_name, ""
    self.new(file_name)
  end

  def initialize(file_name)
    @entries = {}
    @file_name = file_name
    init_hash_from_file
  end

  def add(name, number)
    add_entry_to_hash name, number
    write_hash_to_file
  end

  def remove(name)
    remove_entry_from_hash name
    write_hash_to_file
  end

  # fuzzy search
  def lookup(name)
    @entries.select do |key, value|
      key.include? name
    end
  end

  def reverse(number)
    @entries.invert[number]
  end

  def contains_name? name
    @entries.has_key? name
  end

  def init_hash_from_file()
    if(!File.exist?(@file_name))
      return {}
    end

    file_contents = File.open("./" + @file_name)
    file_contents.each do |line|
      values = line.split(",").map(&:strip)
      # TODO: sanitize phone numbers?
      @entries[values.first] = values.last
    end
    return @entries
  end

  def write_hash_to_file()
    begin
      File.truncate(@file_name, 0)
      File.open(@file_name, 'w') do |file|
        @entries.each do |key, value|
          file.puts key + ", " + value
        end
      end
    rescue
      return false
    end
    return true
  end

  def add_entry_to_hash(name, number)
    @entries[name] = number
  end

  def remove_entry_from_hash(name)
    @entries.delete(name)
  end

end

# interacts with model and prints out results to console
class PhonebookController

  def initialize file_name
    @phonebook = Phonebook.new file_name
  end

  def create file_name
    @phonebook = Phonebook.create file_name
  end

  def lookup name
    filtered = @phonebook.lookup name
    puts "Phonebook entries for name #{name} are: "
    filtered.each do |key, value|
      puts key + " " + value
    end
  end

  def add name, number
    if(@phonebook.contains_name? name)
      puts "Duplicate entry, #{name} is already in phonebook"
      return
    end

    @phonebook.add name, number
    puts "Added entry to phonebook"
  end

  def remove name
    if(!@phonebook.contains_name? name)
      puts "Entry with name #{name} not found, can't delete"
      return
    end

    @phonebook.remove name
    puts "Removed entry from phonebook"
  end

  def reverse number
    entry = @phonebook.reverse number
    unless(entry.nil?)
      puts "Phonebook entry for number #{number}: "
      puts entry + " " + number
    else
      puts "No phonebook entry for number #{number} " unless !entry.nil?
    end
  end
end

def init_options
  args_hash = {"create" => 1, "lookup" => 2, "add" => 3, "remove" => 2, "reverse" => 2}

  # check argument length
  num_expected_args = args_hash[ARGV[0]]
  if (num_expected_args.nil?)
    puts "Must use one of #{args_hash.keys.to_a}"
  end
  if(ARGV[1..-1].length != num_expected_args)
    puts "Number of expected arguments should be #{num_expected_args}"
  end

  # check file exists
  if ARGV[0] != "create"
    if(!File.exist?(ARGV.last))
      puts "File with name #{ARGV.last} doesn't exist, you must create it first"
      return -1
    end
  end

  values = ARGV[1..-1]
  case ARGV[0]
    when "create"
      PhonebookController.create values.last
    when "lookup"
      controller = PhonebookController.new values.last
      controller.lookup(values.first)
    when "add"
      controller = PhonebookController.new(values[-1])
      controller.add(values.first, values[1])
    when "remove"
      controller = PhonebookController.new(values[-1])
      controller.remove(values.first)
    when "reverse"
      controller = PhonebookController.new(values[-1])
      controller.reverse(values.first)
  end
end

if __FILE__ == $0
# start program
  init_options
end


