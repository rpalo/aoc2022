require "./spec_helper"

describe Day10 do
  describe "#part1" do
  it "should evaluate the test file right" do
      Day10.part1("../data/day10_test.txt").should eq(13140)
    end
  end

  describe "#part2" do
    it "should evaluate the test file right" do
      Day10.part2("../data/day10_test.txt").should eq(
        <<-HEREDOC
        ##..##..##..##..##..##..##..##..##..##..
        ###...###...###...###...###...###...###.
        ####....####....####....####....####....
        #####.....#####.....#####.....#####.....
        ######......######......######......####
        #######.......#######.......#######.....
        HEREDOC
      )
    end
  end
end