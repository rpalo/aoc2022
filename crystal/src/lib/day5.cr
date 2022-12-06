# Day 5: Supply Stacks
# 
# Part 1: Shuffle the crates around, following the instructions and
#   report the top character of each stack in order.
# 
# Part 2: Do the same thing, but now the crane keeps the boxes in order
#   rather than pop/pushing them one at a time.
module Day5

  # Represents a series of stacks of crates, each labeled with a single
  # character.  Comes with a crane that can move crates from one pile
  # to another based on a series of instructions.
  class Crates
    @stacks : Array(Array(Char))
    @instructions : Array(String)

    def initialize(stacks, instructions)
      @stacks = stacks
      @instructions = instructions
    end

    # Input file format contains two parts: initial state graph and
    # instructions.
    #
    # Initial state graph looks like this parsing nightmare:
    #
    #     [D]    
    #     [N] [C]    
    # [Z] [M] [P]
    #  1   2   3 
    # 
    # Instructions follow the format: 'move N from X to Y'
    # Stacks numbers are 1-based (like above).
    def self.from_file(filename)
      text = File.read(filename)
      initial, instructions = text.split("\n\n")

      # Convert the text stacks into rows instead of columns for easier
      # handling.  Keep only the (now) rows that start with a number
      # and then drop the numbers and any trailing blank spaces.
      stacks = initial.lines.map(&.chars).transpose
        .map(&.reverse)
        .select { |row| ('1'..'9').includes?(row[-0]) }
        .map { |row| row.select { |c| ('A'..'Z').includes?(c) } }
      self.new(stacks, instructions.lines)
    end

    # Follows each of the instructions in order using `move`
    def execute
      @instructions.each do |instruction|
        move(instruction)
      end
    end

    # Incrementally pops one crate off the top of the source stack
    # and pushes it onto the destination stack, one at a time.
    def move(instruction)
      qty, src, dest = instruction.scan(/\d+/).map do |match|
        match[0].to_i
      end
      qty.times { @stacks[dest - 1].push(@stacks[src - 1].pop) }
    end

    # Follows each of the instructions in order using `move9001`
    def execute9001
      @instructions.each do |instruction|
        move9001(instruction)
      end
    end
    
    # Operates the same as `move`, but picks all N crates up at once
    # and maintains their order as they are added to the destination
    # stack.
    def move9001(instruction)
      qty, src, dest = instruction.scan(/\d+/).map do |match|
        match[0].to_i
      end
      @stacks[dest - 1] += @stacks[src - 1].pop(qty)
    end

    # Reads the top crate's char in each stack and combines them into
    # a single string.
    def read_top
      @stacks.map { |stack| stack[-1] }.join
    end
  end

  def self.part1(filename)
    crates = Crates.from_file(filename)
    crates.execute
    crates.read_top
  end

  def self.part2(filename)
    crates = Crates.from_file(filename)
    crates.execute9001
    crates.read_top
  end

  def self.main(filename)
    puts "Day 5:"
    puts "Part 1: #{part1(filename)}"
    puts "Part 2: #{part2(filename)}"
    puts "=" * 40
  end
end