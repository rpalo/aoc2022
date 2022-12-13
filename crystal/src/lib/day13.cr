require "string_scanner"

# Day 13: Distress Signal
# 
# Part 1: Validate input list pairs
# 
# Part 2: Using this cursed partial ordering, sort all the packets
#   plus two bonus packets.  Then multiply the 1-based indices of the
#   two bonus packets together.
module Day13
  # Proper ordering of integers
  def self.compare(a : Int32, b : Int32)
    a <=> b
  end

  # In Int32 to Array comparisons, nest the Int for a proper comparison
  def self.compare(a : Int32, b : Array(RecInt))
    compare([a], b)
  end

  # In Array to Int32 comparisons, nest the Int for a proper comparison
  def self.compare(a : Array(RecInt), b : Int32)
    compare(a, [b])
  end

  # In Array comparisons, compare all values.  The first differing value
  # decides ordering.  If all values are the same, the shorter Array
  # comes first.
  def self.compare(a : Array(RecInt), b : Array(RecInt))
    min_size = [a.size, b.size].min
    (0...min_size).each do |i|
      result = compare(a[i], b[i])
      return result if !result.zero?
    end
    
    if a.size < b.size
      -1
    elsif a.size > b.size
      1
    else
      0
    end
  end

  alias RecInt = Int32 | Array(RecInt)

  # Parse a line as an infinitely nested array of arrays of ints
  def self.parse(s : StringScanner) : Array(RecInt)
    s.skip(/\[/)
    items = [] of RecInt

    loop do
      if !s.check(/\d+/).nil?
        items << s.scan(/\d+/).as(String).to_i
      elsif !s.check(/\[/).nil?
        items << parse(s)
      elsif !s.check(/\]/).nil?
        s.skip(/\]/)
        return items
      else
        s.skip(/,/)
      end
    end
  end

  def self.part1(filename)
    score = 0
    i = 0
    lines = File.read_lines(filename)

    while !lines.empty?
      i += 1
      a = parse(StringScanner.new(lines.shift))
      b = parse(StringScanner.new(lines.shift))
      score += i if compare(a, b) == -1
      lines.shift if !lines.empty?
    end

    score
  end

  def self.part2(filename)
    lines = File.read_lines(filename).reject {|line| line.blank?}
    packets = [
      [[2]],
      [[6]]
    ] + lines.map {|line| parse(StringScanner.new(line))}
    packets.sort! {|a, b| compare(a, b)}
    (packets.index([[2]]).as(Int32) + 1) * (packets.index([[6]]).as(Int32) + 1)
  end

  def self.main(filename)
    puts "Day 13:"
    puts "Part 1: #{part1(filename)}"
    puts "Part 2: #{part2(filename)}"
    puts "=" * 40
  end
end