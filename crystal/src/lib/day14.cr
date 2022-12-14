# Day 14: Regolith Reservoir
# 
# Part 1: Simulate sand falling and making piles
# 
# Part 2: Add a floor +2 from the lowest rock.  Then count sand needed
#   to come to rest at 500, 0.
module Day14
  # A `Cavern` keeps track of all the *@spaces* filled in by either
  # rock or sand within it (sparse).  It also remembers the *@lowest*
  # y value of a rock after loading in rocks.
  # 
  # It can then simulate sand falling from 500, 0.
  # 
  # Sand falls down until its blocked.  Then it goes down-left, or
  # down-right, or comes to rest.
  # 
  # In scenarios with a floor, it stops 1 row above the floor no matter
  # what.
  class Cavern
    @lowest : Int16
    def initialize
      @spaces = Set({Int16, Int16}).new
      @lowest = 0
    end

    # Read a file where each line is a series of vertical or horizontal
    # segments of rock, of the pattern 475,6 -> 475, 8 -> 490,8 -> ...
    # 
    # Also calculates the *@lowest* after all the rocks are loaded.
    def load_rocks!(filename)
      File.each_line(filename) do |line|
        line.split(" -> ").each_cons_pair do |start, finish|
          start_x, start_y = start.split(",").map(&.to_i16)
          finish_x, finish_y = finish.split(",").map(&.to_i16)
          
          if start_x == finish_x
            start_y, finish_y = finish_y, start_y if start_y > finish_y
            (start_y..finish_y).each do |y|
              @spaces << {start_x, y}
            end
          elsif start_y == finish_y
            start_x, finish_x = finish_x, start_x if start_x > finish_x
            (start_x..finish_x).each do |x|
              @spaces << {x, start_y}
            end
          end
        end
      end

      @lowest = @spaces.max_of {|space| space[1]}
    end

    # Drops sand and returns the quantity that comes to rest before
    # falling off the lowest known rock.
    def count_sand!
      sand = 0
      while !drop_sand!
        sand += 1
      end
      sand
    end

    # Drops sand (with a floor) and counts how much sand it takes
    # until sand comes to rest at the source (500, 0).
    def count_sand_until_source!
      sand = 0
      while !@spaces.includes?({500, 0})
        drop_sand_to_floor!
        sand += 1
      end
      sand
    end

    # Drop one unit of sand until it comes to rest or falls past the
    # lowest known rock.  Return `true` if it falls off the map.
    # Return `false` if it comes to rest.
    def drop_sand!
      x : Int16 = 500
      y : Int16 = 0
      while y <= @lowest
        if !@spaces.includes?({x, y + 1})
          y += 1
        elsif !@spaces.includes?({x - 1, y + 1})
          x -= 1
          y += 1
        elsif !@spaces.includes?({x + 1, y + 1})
          x += 1
          y += 1
        else
          @spaces << {x, y}
          return false
        end
      end
      true
    end

    # Drop one unit of sand until it either comes to rest on rock or sand
    # or comes to rest on the floor.
    def drop_sand_to_floor!
      x : Int16 = 500
      y : Int16 = 0
      floor = @lowest + 1
      while y < floor
        if !@spaces.includes?({x, y + 1})
          y += 1
        elsif !@spaces.includes?({x - 1, y + 1})
          x -= 1
          y += 1
        elsif !@spaces.includes?({x + 1, y + 1})
          x += 1
          y += 1
        else
          @spaces << {x, y}
          return
        end
      end
      @spaces << {x, y}  # Stops on floor
    end

    # String output for debugging.
    def to_s
      output = Array(Char).new
      low_x = @spaces.min_of {|space| space[0]}
      high_x = @spaces.max_of {|space| space[0]}
      (0..@lowest).each do |y|
        (low_x..high_x).each do |x|
          if @spaces.includes?({x, y})
            output << '#'
          else
            output << ' '
          end
        end
        output << '\n'
      end
      output.join
    end
  end

  def self.part1(filename)
    c = Cavern.new
    c.load_rocks!(filename)
    c.count_sand!
  end

  def self.part2(filename)
    c = Cavern.new
    c.load_rocks!(filename)
    c.count_sand_until_source!
  end

  def self.main(filename)
    puts "Day 14:"
    puts "Part 1: #{part1(filename)}"
    puts "Part 2: #{part2(filename)}"
    puts "=" * 40
  end
end