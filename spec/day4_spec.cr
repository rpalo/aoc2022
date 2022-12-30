require "./spec_helper"

describe Day4 do
  describe "#one_fully_contains?" do
    it "should return true for subset a" do
      Day4.one_fully_contains?((1..5), (2..4)).should be_true
    end  
    
    it "should return true for line-to-line subset" do
      Day4.one_fully_contains?((1..5), (1..4)).should be_true
    end

    it "should work in reverse too" do
      Day4.one_fully_contains?((2..4), (1..5)).should be_true
      Day4.one_fully_contains?((1..4), (1..5)).should be_true
    end

    it "should rejects, shifts and non-overlaps" do
      Day4.one_fully_contains?((1..5), (3..10)).should be_false
      Day4.one_fully_contains?((1..5), (6..10)).should be_false
    end
  end

  describe "#overlap?" do
    it "should detect overlaps" do
      Day4.overlap?((1..4), (3..10)).should be_true
      Day4.overlap?((5..10), (1..7)).should be_true
      Day4.overlap?((1..5), (1..5)).should be_true
      Day4.overlap?((1..5), (5..10)).should be_true
      Day4.overlap?((1..10), (4..6)).should be_true
      Day4.overlap?((4..6), (1..10)).should be_true
    end

    it "should reject non-overlaps" do
      Day4.overlap?((1..5), (6..10)).should be_false
    end
  end

  describe "#part1" do
    it "should evaluate the test file right" do
      Day4.part1("data/day4_test.txt").should eq(2)
    end
  end

  describe "#part2" do
    it "should evaluate the test file right" do
      Day4.part2("data/day4_test.txt").should eq(4)
    end
  end
end