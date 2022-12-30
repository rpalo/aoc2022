# Day 12: Hill Climbing Algorithm
# 
# Part 1: Climb a mountain in the fewest horizontal steps.  You can 
#   increase your elevation by max 1 in each step.  a is lowest, z is
#   highest, S is start, E is target.
# 
# Part 2: Find the shortest path from any a-level elevation
module Day12
  # A Cell knows its elevation and that of its neighbors.  A cell's
  # neighbors will never be more than 1 elevation taller than them
  # (more correctly "valid neighbors")
  class Cell
    @height : Char
    getter height
    property neighbors

    def initialize(@height)
      @neighbors = Array(Cell).new
    end
  end

  # A Grid is a 2D matrix of `Cell`s that include a special *@start*
  # and *@goal* cells marked 'S' and 'E' respectively.  Can find the
  # best path to E from anywhere, and can find the best 'a'-level
  # cell to start from.
  class Grid
    @start : Cell
    @goal : Cell
    @grid : Array(Array(Cell))
    getter start
    getter goal

    def initialize(rows)
      @start = Cell.new('\0')
      @goal = Cell.new('\0')
      width = rows[0].size
      height = rows.size
      @grid = rows.map do |row|
                row.map do |c|
                  if c == 'S'
                    @start = Cell.new('a')
                    @start
                  elsif c == 'E'
                    @goal = Cell.new('z')
                    @goal
                  else
                    Cell.new(c)
                  end
                end
              end
      (0...height).each do |y|
        (0...width).each do |x|
          if y > 0
            @grid[y][x].neighbors << @grid[y - 1][x]
            @grid[y - 1][x].neighbors << @grid[y][x]
          end
          if x > 0
            @grid[y][x].neighbors << @grid[y][x - 1]
            @grid[y][x - 1].neighbors << @grid[y][x]
          end
        end
      end

      @grid.flatten.each do |cell|
        cell.neighbors.select! {|n| n.height - cell.height <= 1}
      end
    end

    # Find the best path from *cell* (or *@start* by default) to *@goal*.
    def find_best_path(cell : Cell? = nil)
      cell ||= @start
      frontier = [[cell]]
      seen = Set(Cell).new
      while !frontier.empty?
        current = frontier.shift
        next if seen.includes?(current[-1])
        
        return current if current[-1] == @goal
        
        seen << current[-1]
  
        current[-1].neighbors.each do |n|
          frontier << current + [n]
        end
      end
  
      raise "Couldn't find it."
    end

    # Find the best 'a'-level cell to start from.
    def find_best_start
      @grid.flatten.select {|cell| cell.height == 'a'}.min_of do |cell|
        begin
          find_best_path(cell).size - 1
        rescue
          Int32::MAX
        end
      end
    end
  end

  def self.part1(filename)
    g = Grid.new(File.read_lines(filename).map(&.chars))
    g.find_best_path.size - 1  # Don't count the starting square.
  end

  def self.part2(filename)
    g = Grid.new(File.read_lines(filename).map(&.chars))
    g.find_best_start
  end

  def self.main(filename)
    puts "Day 12:"
    puts "Part 1: #{part1(filename)}"
    puts "Part 2: #{part2(filename)}"
    puts "=" * 40
  end
end