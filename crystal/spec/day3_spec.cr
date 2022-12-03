require "./spec_helper"

describe Day3 do
  describe "#part1" do
    it "should evaluate the test file right" do
      Day3.part1("../data/day3_test.txt").should eq(157)
    end
  end

  describe "#part2" do
    it "should evaluate the test file right" do
      Day3.part2("../data/day3_test.txt").should eq(70)
    end
  end
end