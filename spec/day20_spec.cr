require "./spec_helper"

describe Day20 do
  describe "#part1" do
  it "should evaluate the test file right" do
      Day20.part1("data/day20_test.txt").should eq(3)
    end
  end

  describe "#part2" do
    it "should evaluate the test file right" do
      Day20.part2("data/day20_test.txt").should eq(1623178306)
    end
  end
end