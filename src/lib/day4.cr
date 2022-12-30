# Day 4: Camp Cleanup
# 
# Part 1: Detect pairs where one is a subset of the other
# 
# Part 2: Detect pairs where there is any overlap at all
module Day4
  # Returns true if either *a* fully contains *b* or *b* fully contains *a*.
  # *a* and *b* are ranges.
  def self.one_fully_contains?(a, b)
    (a.includes?(b.begin) && a.includes?(b.end)) ||
    (b.includes?(a.begin) && b.includes?(a.end))
  end

  # Returns true if the ranges *a* and *b* touch at all, even at a single
  # point, and even in states of total overlap either way.
  def self.overlap?(a, b)
    a.includes?(b.begin) || a.includes?(b.end) || one_fully_contains?(a, b)
  end

  # Takes a filename and returnes an enumerator yielding pairs of elf
  # workload ranges, *a* and *b*
  def self.each_pair(filename)
    File.read_lines(filename).map do |line|
      a, b = line.split(",")
      a_start, a_stop = a.split("-").map(&.to_i)
      b_start, b_stop = b.split("-").map(&.to_i)
      {(a_start..a_stop), (b_start..b_stop)}
    end
  end

  # Counts the number of total overlaps in the input
  def self.part1(filename)
    each_pair(filename).count do |a, b|
      one_fully_contains?(a, b)
    end
  end

  # Counts the number of total or partial overlaps in the input
  def self.part2(filename)
    each_pair(filename).count do |a, b|
      overlap?(a, b)
    end
  end

  def self.main(filename)
    puts "Day 4:"
    puts "Part 1: Total overlaps: #{part1(filename)}"
    puts "Part 2: Partial overlaps: #{part2(filename)}"
    puts "=" * 40
  end
end