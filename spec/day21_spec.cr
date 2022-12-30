require "./spec_helper"

describe Day21 do
  describe "#part1" do
  it "should evaluate the test file right" do
      Day21.part1("data/day21_test.txt").should eq(152)
    end
  end

  describe "#part2" do
    it "should evaluate the test file right" do
      Day21.part2("data/day21_test.txt").should eq(301)
    end
  end
end