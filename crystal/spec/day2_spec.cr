require "./spec_helper"

describe Day2 do
  describe "#score" do
    it "scores ties" do
      Day2.score('A', 'X').should eq(4)
      Day2.score('B', 'Y').should eq(5)
      Day2.score('C', 'Z').should eq(6)
    end

    it "scores victories" do
      Day2.score('A', 'Y').should eq(8)
      Day2.score('B', 'Z').should eq(9)
      Day2.score('C', 'X').should eq(7)
    end

    it "scores losses" do
      Day2.score('A', 'Z').should eq(3)
      Day2.score('B', 'X').should eq(1)
      Day2.score('C', 'Y').should eq(2)
    end
  end

  describe "#sum_rounds" do
    it "should add up the test file" do
      Day2.sum_rounds("../data/day2_test.txt").should eq(15)
    end
  end

  describe "#sum_rounds2" do
    it "should add up the test file" do
      Day2.sum_rounds2("../data/day2_test.txt").should eq(12)
    end
  end
end