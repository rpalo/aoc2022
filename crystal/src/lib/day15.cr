# Day 15: Beacon Exclusion Zone
# 
# Part 1: Count the number of spaces that definitely could not include
#   the mystery beacon in row 2,000,000 (row 10 in test)
# 
# Part 2: Find the one space not ruled out by Part 1 logic all over the
#   space.
module Day15
  # A `Pair` is a Beacon/Closest Sensor pair that keeps track of the
  # x and y coords for both beacon and sensor.
  # 
  # It has methods for how far away beacon and sensor are (Manhattan)
  # as well as how far away other sensors are from this one.
  class Pair
    getter sx : Int64
    getter sy : Int64
    getter bx : Int64
    getter by : Int64
    def initialize(@sx, @sy, @bx, @by)
    end

    def distance
      (@sx - @bx).abs + (@sy - @by).abs
    end

    def distance(other : Pair)
      (@sx - other.sx).abs + (@sy - other.sy).abs
    end
  end

  # Parse files of the pattern blah blah sensor x=12, y=-34, blah beacon x=12, y=34
  # into `Pair`s.
  def self.parse(filename)
    File.read_lines(filename).map do |line|
      sx, sy, bx, by = line.scan(/-?\d+/).map { |match| match[0].to_i64 }
      Pair.new(sx, sy, bx, by)
    end
  end

  # Return ranges that definitely couldn't contain any beacons.
  # Possibly overlapping.
  def self.slice_exclusion_zones(pairs, row)
    pairs.map do |pair|
      dist_at_row = pair.distance - (pair.sy - row).abs
      (pair.sx - dist_at_row)..(pair.sx + dist_at_row)
    end.sort_by(&.begin)
  end

  # Reduce possibly overlapping ranges to the minumum number of 
  # non-overlapping ranges.  Also, for convenience, return the
  # value of minimum overlap found.  This allows us to know
  # that the results won't change for a few rows.
  def self.reduce(ranges)
    min_overlap = 4_000_000
    reduced = ranges[1..].reduce([ranges[0]]) do |acc, range|
      if range.begin <= acc[-1].end && acc[-1].end < range.end
        overlap = acc[-1].end - range.begin
        min_overlap = overlap if overlap < min_overlap
        acc[-1] = (acc[-1].begin..range.end)
      elsif acc[-1].begin <= range.begin && range.end <= acc[-1].end
        # Ignore
      else
        acc << range
      end
      acc
    end
    {reduced, min_overlap}
  end

  def self.part1(filename, row)
    pairs = parse(filename).select { |pair| (pair.sy - row).abs <= pair.distance }
    ranges = slice_exclusion_zones(pairs, row)
    covered = reduce(ranges)[0].sum(&.size)

    objs_in_row = pairs.select {|pair| pair.sy == row}.map(&.sx).uniq.size +
      pairs.select {|pair| pair.by == row}.map(&.bx).uniq.size
    
    covered - objs_in_row
  end

  # For performance reasons, we can ignore any `Pair`s that are fully
  # contained within the "realm" of another `Pair`.
  def self.strip_overlaps(pairs)
    removes = pairs.combinations(2).select do |pair_pair|
      a, b = pair_pair
      a.distance >= a.distance(b) + b.distance
    end.map { |pair_pair| pair_pair.min_by(&.distance) }
    pairs.reject { |pair| removes.includes?(pair) }
  end

  def self.part2(filename, max_val) : Int64
    pairs = parse(filename)
    pairs = strip_overlaps(pairs)
    row = 0
    while row <= max_val
      close_pairs = pairs.select { |pair| (pair.sy - row).abs <= pair.distance }
      ranges = slice_exclusion_zones(close_pairs, row)
      reduced, min_overlap = reduce(ranges)

      if reduced.size > 1 && reduced[1].begin - reduced[0].end == 2
        return (reduced[0].end + 1) * 4_000_000_i64 + row
      end

      if min_overlap // 2 != 0
        row += min_overlap // 2
      else
        row += 1
      end
    end
    raise "Not found"
  end

  def self.main(filename)
    puts "Day 15:"
    puts "Part 1: #{part1(filename, 2_000_000)}"
    puts "Part 2: #{part2(filename, 4_000_000)}"
    puts "=" * 40
  end
end