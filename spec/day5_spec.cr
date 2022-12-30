require "./spec_helper"

describe Day5 do
  describe "#part1" do
  it "should evaluate the test file right" do
      Day5.part1("data/day5_test.txt").should eq("CMZ")
    end
  end

  describe "#part2" do
    it "should evaluate the test file right" do
      Day5.part2("data/day5_test.txt").should eq("MCD")
    end
  end
end