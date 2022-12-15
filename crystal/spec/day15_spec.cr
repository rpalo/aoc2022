require "./spec_helper"

describe Day15 do
  describe "#part1" do
  it "should evaluate the test file right" do
      Day15.part1("../data/day15_test.txt", 10).should eq(26)
    end
  end

  describe "#part2" do
    it "should evaluate the test file right" do
      Day15.part2("../data/day15_test.txt", 20).should eq(56000011)
    end
  end
end