require "./spec_helper"

describe Day2 do
  describe "#score" do
    it "scores ties" do
      d = Day2.new
      d.score('A', 'X').should eq(4)
      d.score('B', 'Y').should eq(5)
      d.score('C', 'Z').should eq(6)
    end

    it "scores victories" do
      d = Day2.new
      d.score('A', 'Y').should eq(8)
      d.score('B', 'Z').should eq(9)
      d.score('C', 'X').should eq(7)
    end

    it "scores losses" do
      d = Day2.new
      d.score('A', 'Z').should eq(3)
      d.score('B', 'X').should eq(1)
      d.score('C', 'Y').should eq(2)
    end
  end

  describe "#sum_rounds" do
    it "should add up the test file" do
      d = Day2.new
      d.sum_rounds("../data/day2_test.txt").should eq(15)
    end
  end

  describe "#sum_rounds2" do
    it "should add up the test file" do
      d = Day2.new
      d.sum_rounds2("../data/day2_test.txt").should eq(12)
    end
  end
end