# Day 1: Calorie Counting
# 
# Figure out which elves have the most calories in snacks
class Day1
  getter elves : Array(Int32)

  def initialize
    @elves = [] of Int32
  end

  def parse(filename)
    @elves << 0
    File.each_line(filename) do |line|
      if line.empty?
        @elves << 0
      else
        @elves[-1] += line.to_i
      end
    end
    @elves = @elves.sort.reverse
  end

  def most_calories
    @elves.first
  end

  def top_three_sum
    @elves[..2].sum
  end

  def main(filename)
    parse(filename)
    puts "Day 1:"
    puts "Part 1: Most calories: #{most_calories}"
    puts "Part 2: Sum of top 3: #{top_three_sum}"
    puts "=" * 40
  end
end