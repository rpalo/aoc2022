require "./spec_helper"

describe Day14 do
  describe "#part1" do
  it "should evaluate the test file right" do
      Day14.part1("../data/day14_test.txt").should eq(24)
    end
  end

  describe "#part2" do
    it "should evaluate the test file right" do
      Day14.part2("../data/day14_test.txt").should eq(93)
    end
  end
end