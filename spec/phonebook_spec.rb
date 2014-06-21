# require 'spec_helper'
require_relative '../phonebook'

describe "Phonebook object" do

  before :all do
    entries = "Sarah Ahmed, 432 123 4321\nSarah Apple, 509 123 4567\nSarah Orange, 123 456 789"

    File.open "phonebook-test.pb", "w" do |file|
      file.puts entries
    end
  end

  before :each do
    @phonebook = Phonebook.new "phonebook-test.pb"
  end


  # describe "#new" do
  #   context "with no parameters" do
  #     it "has no entries" do
  #       phonebook = Phonebook.new
  #       lib.should have(0).books
  #     end
  #   end
  #   context "with a yaml file parameter" do
  #     it "has five books" do
  #       @lib.should have(5).books
  #     end
  #   end
  # end
  describe "#new" do
    it "takes one parameter and returns a Phonebook object" do
      expect(@phonebook).to be_a Phonebook
      expect(@phonebook.entries.length).to eql 3
    end
  end

  describe "#file_name" do
    it "returns the correct file name" do
      expect(@phonebook.file_name).to eql "phonebook-test.pb"
    end
  end

  describe "#entries" do
    it "returns 3 correct entries" do
      expect(@phonebook.entries).to_not be_empty
      expect(@phonebook.entries.length).to eq 3
    end
  end

  describe "#add" do
    it "adds a new entry to entries" do
      @phonebook.add("dean", 1234567)

      entries = @phonebook.entries
      expect(entries.length).to eql 4
      expect(entries.has_key? "dean").to eql true
      expect(entries["dean"]).to eql 1234567
    end
  end

  describe "#reverse" do
    it "finds the name when given a number" do
      @phonebook.entries["dean"] = 1234567

      result = @phonebook.reverse 1234567
      expect(result).to eql "dean"
    end
  end

  describe "#contains_name?" do
    it "finds returns true if the name exists in entries" do
      @phonebook.entries["dean"] = 1234567

      result = @phonebook.contains_name? "dean"
      expect(result).to eql true
    end
  end

end
