require "./spec_helper"

describe Day12 do
  describe "#part1" do
  it "should evaluate the test file right" do
      Day12.part1("data/day12_test.txt").should eq(31)
    end
  end

  describe "#part2" do
    it "should evaluate the test file right" do
      Day12.part2("data/day12_test.txt").should eq(29)
    end
  end
end