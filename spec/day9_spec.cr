require "./spec_helper"

describe Day9 do
  describe "#part1" do
  it "should evaluate the test file right" do
      Day9.part1("data/day9_test.txt").should eq(13)
    end
  end

  describe "#part2" do
    it "should evaluate the test file right" do
      Day9.part2("data/day9_test.txt").should eq(1)
    end
    
    it "should evaluate the bigger test right" do
      Day9.part2("data/day9_test2.txt").should eq(36)
    end
  end
end