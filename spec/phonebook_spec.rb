require_relative '../phonebook'

describe Phonebook do

  before :each do
    @phonebook = Phonebook.new "file_name.txt"
  end

  describe "#new" do
    it "takes one parameter and returns a Phonebook object" do
      expect(@phonebook).to be_a Phonebook
    end
  end

  describe "#file_name" do
    it "returns the correct file name" do
      expect(@phonebook.file_name).to eql "file_name.txt"
    end
  end

  describe "#entries" do
    it "returns correct entries" do
      expect(@phonebook.entries).to be_empty
    end
  end
end