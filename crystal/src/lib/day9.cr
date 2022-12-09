# Day 9: Rope Bridge
# 
# Part 1: Simulate two moving points connected by a rope.
# 
# Part 2: Simulate a chain of ropes.
module Day9
  # A Knot is a 2D coordinate point (at the end of a virtual rope)
  class Knot
    property x
    property y
    
    def initialize
      @x = 0
      @y = 0
    end
  end

  # A `Rope` is a pair of `Knot`s connected by a virtual rope that is 1
  # grid-unit long either horizontally, vertically, or diagonally.
  # If the *@head* moves more than that away from the *@tail*, the *@tail*
  # must shift to catch up (assuming you call `update_tail!` after
  # every time the *@head* is moved.
  # 
  # Because Part 2 demands it, the *@head* can be moved via the `move!`
  # method or based on the movement of another connected rope's *@tail*.
  # 
  # In this way, multiple `Rope`s can be strung together to create a
  # chain!
  class Rope
    property head
    property tail

    def initialize
      @head = Knot.new
      @tail = Knot.new
      @squares = [{0, 0}].to_set
    end

    # Moves the head of the rope one space in the specified *dir*
    # and then updates the *@tail* to obey rope physics.
    def move!(dir)
      case dir
      when "U"
        @head.y += 1
      when "D"
        @head.y -= 1
      when "L"
        @head.x -= 1
      when "R"
        @head.x += 1
      end
      update_tail!
    end
    
    # Grid pattern for my sanity:

    # # + + + #
    # + o o o +
    # + o x o +
    # + o o o +
    # # + + + #

    # Based on the position of the *@head*, pull the *@tail* into the
    # position it needs to be MAX 1 square away.
    #
    # Also, keep track of all the squares the tail has seen.  For science.
    def update_tail!
      return if dist <= 1

      case {xdiff, ydiff}
      when {2, 0}
        @tail.x += 1
      when {2, -1}, {1, -2}, {2, -2}
        @tail.x += 1
        @tail.y -= 1
      when {0, -2}
        @tail.y -= 1
      when {-1, -2}, {-2, -1}, {-2, -2}
        @tail.x -= 1
        @tail.y -= 1
      when {-2, 0}
        @tail.x -= 1
      when {-2, 1}, {-1, 2}, {-2, 2}
        @tail.x -= 1
        @tail.y += 1
      when {0, 2}
        @tail.y += 1
      when {1, 2}, {2, 1}, {2, 2}
        @tail.x += 1
        @tail.y += 1
      end
      @squares << {@tail.x, @tail.y}
    end

    @[AlwaysInline]
    def xdiff
      @head.x - @tail.x
    end

    @[AlwaysInline]
    def ydiff
      @head.y - @tail.y
    end

    @[AlwaysInline]
    def dist
      xdiff.abs + ydiff.abs
    end

    # Return a count of the unique squares the tail has been in at 
    # least once.
    def visited
      @squares.size
    end
  end

  # A `Chain` is a series of chained `Rope`s where the first `Rope`'s 
  # *@tail* is the *@head* of the next one.
  # 
  # Uses *size* `Rope`s altogether.
  class Chain
    @links : Array(Rope)

    def initialize(size)
      @head = Rope.new
      current = @head
      @links = (size - 1).times.map do
        link = Rope.new
        link.head = current.tail
        current = link
        link
      end.to_a
    end

    # Move the *@head* of the first `Rope` and then update the *@tail*s
    # of all subsequent `Rope`s.
    def move!(direction)
      @head.move!(direction)
      @links.each { |link| link.update_tail! }
    end

    # Make it easy to find how many unique squares the *@tail* of the
    # very last `Rope` visited.  For science.
    def tail_visited
      @links[-1].visited
    end
  end

  def self.part1(filename)
    rope = Rope.new
    File.each_line(filename) do |line|
      dir, qty = line.split
      qty.to_i.times {rope.move!(dir)}
    end
    rope.visited
  end

  def self.part2(filename)
    chain = Chain.new(9)
    File.each_line(filename) do |line|
      dir, qty = line.split
      qty.to_i.times { chain.move!(dir) }
    end
    chain.tail_visited
  end

  def self.main(filename)
    puts "Day 9:"
    puts "Part 1: #{part1(filename)}"
    puts "Part 2: #{part2(filename)}"
    puts "=" * 40
  end
end