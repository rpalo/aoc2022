# Day 23: Unstable Diffusion
# 
# Part 1: Space out elves evenly and count the spaces between them.
# 
# Part 2: What is the first round that no elf moved.
module Day23
  # An Elf knows where it is in 2D space
  class Elf
    getter x : Int32
    getter y : Int32
    def initialize(@x, @y)
    end

    def pair
      {@x, @y}
    end

    # Check around yourself and and propose moving to a new location.
    # Do not propose anything if no options are available.  Do not
    # propose anything if you have no adjacent or diagonal neighbors
    # (i.e. happy).
    # Propose the first direction out of *checks* that works
    def propose(checks, locations)
      options = Array(Tuple(Int32, Int32)).new
      checks.each do |dir|
        case dir
        when "N"
          if !(
            locations.includes?({@x - 1, @y - 1}) ||
            locations.includes?({@x, @y - 1}) ||
            locations.includes?({@x + 1, @y - 1})
          )
            options << {@x, @y - 1}
          end
        when "S"
          if !(
            locations.includes?({@x - 1, @y + 1}) ||
            locations.includes?({@x, @y + 1}) ||
            locations.includes?({@x + 1, @y + 1})
          )
            options << {@x, @y + 1}
          end
        when "W"
          if !(
            locations.includes?({@x - 1, @y - 1}) ||
            locations.includes?({@x - 1, @y}) ||
            locations.includes?({@x - 1, @y + 1})
          )
            options << {@x - 1, @y}
          end
        when "E"
          if !(
            locations.includes?({@x + 1, @y - 1}) ||
            locations.includes?({@x + 1, @y}) ||
            locations.includes?({@x + 1, @y + 1})
          )
            options << {@x + 1, @y}
          end
        else
          raise "Bad check"
        end
      end
      if options.size == 4
        nil
      elsif options.empty?
        nil
      else
        options[0]
      end
    end

    def move(location)
      @x, @y = location
    end
  end

  # Parse the input file into a list of Elves that know where they are
  def self.parse(filename)
    grid = File.read_lines(filename).map(&.chars)
    elves = Array(Elf).new

    grid.each_with_index do |row, j|
      row.each_with_index do |c, i|
        if c == '#'
          elves << Elf.new(i, j)
        end
      end
    end
    elves
  end

  # Have each elve evaluate their location and propose a new one, and
  # then move, in a 2-step process.  Do not accept moves from any
  # elves that propose the same location.  Return the number of moves
  # allowed.
  def self.disperse(elves, checks)
    current_positions = elves.map(&.pair).to_set
    proposed = Set(Tuple(Int32, Int32)).new
    rejected = Set(Tuple(Int32, Int32)).new
    accepted = Array(Tuple(Elf, Tuple(Int32, Int32))).new

    elves.each do |elf|
      location = elf.propose(checks, current_positions)
      next if location.nil?
      if rejected.includes?(location)
        next
      elsif proposed.includes?(location)
        proposed.delete(location)
        rejected << location
      else
        proposed << location
        accepted << {elf, location}
      end
    end

    count = 0
    accepted.each do |elf, location|
      if proposed.includes?(location)
        elf.move(location)
        count += 1
      end
    end
    count
  end

  # Count up the number of empty spaces within the tightest vertical
  # rectangular bounding box surrounding all the elves.
  def self.empty_ground(elves)
    w = elves.min_of(&.x)
    e = elves.max_of(&.x)
    n = elves.min_of(&.y)
    s = elves.max_of(&.y)
    (s - n + 1) * (e - w + 1) - elves.size
  end

  def self.part1(filename)
    elves = parse(filename)
    checks = ["N", "S", "W", "E"]
    10.times do
      disperse(elves, checks)
      checks << checks.shift
    end
    empty_ground(elves)
  end

  def self.print_elves(elves)
    print("\033[2J")
    locations = elves.map(&.pair).to_set
    (-25..120).each do |y|
      (-25..120).each do |x|
        if locations.includes?({x, y})
          print("#")
        else
          print(".")
        end
      end
      print("\n")
    end
  end

  def self.part2(filename)
    elves = parse(filename)
    checks = ["N", "S", "W", "E"]
    (0..).each do |i|
      n = disperse(elves, checks) 
      if n == 0
        return i + 1
      end
      checks << checks.shift
    end
  end

  def self.main(filename)
    puts "Day 23:"
    puts "Part 1: #{part1(filename)}"
    puts "Part 2: #{part2(filename)}"
    puts "=" * 40
  end
end
