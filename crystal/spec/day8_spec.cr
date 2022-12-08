require "./spec_helper"

describe Day8 do
  describe "#part1" do
  it "should evaluate the test file right" do
      Day8.part1("../data/day8_test.txt").should eq(21)
    end
  end

  describe "#part2" do
    it "should evaluate the test file right" do
      Day8.part2("../data/day8_test.txt").should eq(8)
    end
  end
end