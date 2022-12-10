# Day 10: Cathode Ray Tube
# 
# Part 1: Calculate signal strengths of the communicator at particular
#   operation cycle numbers
# 
# Part 2: Print out an image based on pixels, clock timing, and sprite
#   location?  For science?
module Day10
  # Enumerable that outputs cycle * X register value during cycle 20
  # and every 40 cycles after that.  X register is updated AFTER the
  # cycle, not during.
  class Communicator
    include Enumerable(Int32)
    @filename : String

    def initialize(@filename)
    end

    def each
      cycle = 0
      x = 1
      File.each_line(@filename) do |line|
        if line == "noop"
          cycle += 1
          yield cycle * x if (cycle - 20) % 40 == 0
        elsif line.starts_with?("addx")
          value = line.split.last.to_i
          cycle += 1
          yield cycle * x if (cycle - 20) % 40 == 0
          cycle += 1
          yield cycle * x if (cycle - 20) % 40 == 0
          x += value
        end
        return if cycle > 220
      end
    end
  end

  # A CRT Communicator builds a string 40 char wide x 6 lines tall.
  # Each char is a # if the X register is within 1 of the current
  # pixel being drawn's X location, and a . otherwise.
  #
  # The output for the puzzle should be recognizable letters.
  class CRTCommunicator
    include Enumerable(Char)
    @filename : String

    def initialize(@filename)
      @x = 1
      @cycle = 0
    end

    def paint_char
      x_pos = @cycle % 40
      if (@x - x_pos).abs <= 1
        '#'
      else
        '.'
      end
    end

    macro newline_check
      yield '\n' if @cycle % 40 == 0 && @cycle > 0
    end

    # While cycles are 1-based, X and pixels are 0-based.
    # First we output a newline if we reached the end of the row on the
    # last tick.  
    # Then we output the paint character.
    # Then we increment the cycle.
    # Then, we perform any pending add actions if any.
    def each
      File.each_line(@filename) do |line|
        if line == "noop"
          newline_check
          yield paint_char
          @cycle += 1
        elsif line.starts_with?("addx")
          value = line.split.last.to_i
          newline_check
          yield paint_char
          @cycle += 1
          newline_check
          yield paint_char
          @cycle += 1
          @x += value
        end
        return if @cycle >= 240
      end
    end
  end

  def self.part1(filename)
    Communicator.new(filename).sum
  end

  def self.part2(filename)
    CRTCommunicator.new(filename).join
  end

  def self.main(filename)
    puts "Day 10:"
    puts "Part 1: #{part1(filename)}"
    puts "Part 2: \n#{part2(filename)}"
    puts "=" * 40
  end
end