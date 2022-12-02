require "./spec_helper.cr"

describe Day1 do
  it "should parse input properly" do
    a = Day1.new
    a.parse("../data/day1_test.txt")
    a.elves.should eq([24000, 11000, 10000, 6000, 4000])
  end

  it "should find the max calorie elf" do
    a = Day1.new
    a.parse("../data/day1_test.txt")
    a.most_calories.should eq(24000)
  end

  it "should properly sum the top 3" do
    a = Day1.new
    a.parse("../data/day1_test.txt")
    a.top_three_sum.should eq(45000)
  end
end