require "./spec_helper"

describe Day23 do
  describe "#part1" do
  it "should evaluate the test file right" do
      Day23.part1("data/day23_test.txt").should eq(110)
    end
  end

  describe "#part2" do
    it "should evaluate the test file right" do
      Day23.part2("data/day23_test.txt").should eq(20)
    end
  end
end