require "./spec_helper"
require "string_scanner"

describe Day13 do
  describe ".compare" do
    it "should compare flat same-length lists by number" do
      Day13.compare([1, 1, 3, 1, 1], [1, 1, 5, 1, 1]).should eq(-1)
    end

    it "should properly cast integers to lists and compare list lengths" do
      Day13.compare([[1], [2, 3, 4]], [[1], 4]).should eq(-1)
    end

    it "should properly cast" do
      Day13.compare([9], [[8, 7, 6]]).should eq(1)
    end

    it "should do direct size comparisons" do
      Day13.compare([[4, 4], 4, 4], [[4, 4], 4, 4, 4]).should eq(-1)
    end

    it "should handle empty lists" do
      Day13.compare([] of Int32, [3]).should eq(-1)
    end

    it "should handle nested empty lists" do
      Day13.compare([[[] of Int32]], [[] of Int32]).should eq(1)
    end

    it "should get complicated" do
      Day13.compare([1,[2,[3,[4,[5,6,7]]]],8,9], [1,[2,[3,[4,[5,6,0]]]],8,9]).should eq(1)
    end
  end

  describe "#part1" do
  it "should evaluate the test file right" do
      Day13.part1("../data/day13_test.txt").should eq(13)
    end
  end

  describe "#part2" do
    it "should evaluate the test file right" do
      Day13.part2("../data/day13_test.txt").should eq(140)
    end
  end
end