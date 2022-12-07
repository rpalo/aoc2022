require "./spec_helper"

describe Day7 do
  describe "#part1" do
  it "should evaluate the test file right" do
      Day7.part1("../data/day7_test.txt").should eq(95437)
    end
  end

  describe "#part2" do
    it "should evaluate the test file right" do
      Day7.part2("../data/day7_test.txt").should eq(24933642)
    end
  end
end