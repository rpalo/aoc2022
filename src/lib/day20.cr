# Day 20: Grove Positioning System
# 
# Part 1: "Mix" a list according to a special decryption algorithm.
# 
# Part 2: Increase complexity by first mutiplying
#   by the decryption key.  Then mix 10 times.
module Day20
  # A TaggedNumber remembers the order it should be mixed in.
  class TaggedNumber
    getter val : Int64
    getter id : Int32
    
    def initialize(@val, @id)
    end
  end

  def self.parse(filename)
    File.read_lines(filename).map_with_index { |numstr, i| TaggedNumber.new(numstr.to_i, i) }
  end

  # Shift each number from its current position to a new position offset
  # by its value.  Wrap around.
  def self.mix!(numbers : Array(TaggedNumber))
    (0..numbers.max_of(&.id)).each do |id|
      num = numbers.find { |n| n.id == id }.as(TaggedNumber)
      index = numbers.index(num).as(Int32)
      numbers.delete_at(index)
      if (index + num.val) % numbers.size == 0
        numbers.insert(-1, num)
      else
        numbers.insert((index + num.val) % numbers.size, num)
      end
    end
  end

  def self.coords(numbers)
    start = numbers.index(numbers.find {|n| n.val == 0}).as(Int32)
    numbers[(1000 + start) % numbers.size].val + 
    numbers[(2000 + start) % numbers.size].val +
    numbers[(3000 + start) % numbers.size].val
  end

  def self.part1(filename)
    numbers = parse(filename)
    mix!(numbers)
    coords(numbers)
  end

  DECRYPTION_KEY = 811589153

  def self.parse2(filename)
    File.read_lines(filename).map_with_index do |numstr, i|
      TaggedNumber.new(numstr.to_i64 * DECRYPTION_KEY, i)
    end
  end

  def self.mix2!(numbers)
    10.times do
      (0..numbers.max_of(&.id)).each do |id|
        num = numbers.find { |n| n.id == id }.as(TaggedNumber)
        index = numbers.index(num).as(Int32).to_i64
        numbers.delete_at(index)
        if (index + num.val) % numbers.size == 0
          numbers.insert(-1, num)
        else
          numbers.insert((index + num.val) % numbers.size, num)
        end
      end
    end
  end

  def self.part2(filename)
    numbers = parse2(filename)
    mix2!(numbers)
    coords(numbers)
  end

  def self.main(filename)
    puts "Day 20:"
    puts "Part 1: #{part1(filename)}"
    puts "Part 2: #{part2(filename)}"
    puts "=" * 40
  end
end

