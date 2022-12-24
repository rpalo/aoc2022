require "./spec_helper"

describe Day18 do
  describe "#part1" do
  it "should evaluate the test file right" do
      Day18.part1("../data/day18_test.txt").should eq(64)
    end
  end

  describe "#part2" do
    it "should evaluate the test file right" do
      Day18.part2("../data/day18_test.txt").should eq(58)
    end
  end
end