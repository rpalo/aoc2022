# Day 8: Treetop Tree House
# 
# Part 1: How many trees in the forest are visible from some direction
#   from outside the forest.  Trees are only visible if all the trees
#   in front of them are shorter than them.
# 
# Part 2: Find the best scenic score, which is, effectively, which
#   tree can see the most other trees
module Day8

  # A tree in a forest.  Keeps track of whether it can see the edge
  # of the forest in each direction, as well as its *height*
  # 
  # NOTE: After it gets loaded into a Forest, the forest must call
  # `Forest#detect_visibility` for the directional view properties 
  # to be accurate.
  class Tree
    @height : Int8

    getter height
    property north
    property south
    property east
    property west

    def initialize(@height)
      @north = true
      @south = true
      @east = true
      @west = true
    end
  end

  # A `Forest` is a 2D grid of trees.
  class Forest
    @grid : Array(Array(Tree))

    def initialize(grid)
      @grid = grid
    end

    # Load from a 2D txt file where each tree is represented by a digit
    # specifying its height.
    # 
    # Assumes grid rows are uniform width.
    def self.from_file(filename)
      grid = File.read_lines(filename).map do |line|
        line.chars.map do |c| 
          Tree.new(c.to_i8)
        end
      end
      self.new(grid)
    end

    # Rule out visibility for trees from the left direction, then
    # rotate the grid 90 degrees.  Simple code-saving macro.
    # Expects you *dirs* to be 4 items long to return the grid to 
    # the original orientation.
    macro detect_visibility_template(dirs)
      {% for direction in dirs %}
        @grid.each do |row|
          tallest = -1
          row.each do |tree|
            if tree.height <= tallest
              tree.{{direction}} = false
            else
              tallest = tree.height
            end
          end
        end
        rotate!
      {% end %}
    end

    def detect_visibility
      detect_visibility_template [west, south, east, north]
    end

    # Rotate *@grid* 90 degrees to the right.
    def rotate!
      @grid = @grid.transpose.map(&.reverse)
    end

    # Count the number of trees that are visible from one edge of the
    # map (assuming visibility has already been detected).
    def count_visible
      @grid.sum do |row|
        row.count do |tree|
          [tree.north, tree.south, tree.east, tree.west].any?
        end
      end
    end

    # Visualize which trees are visible from the edge of the map for
    # debugging.
    def puts_visible
      print "\n"
      @grid.each do |row|
        row.each do |tree|
          if tree.north || tree.south || tree.east || tree.west
            print "+"
          else
            print " "
          end
        end
        print "\n"
      end
    end

    # Should output the same grid of digits that `Forest.from_file` loaded in.
    def to_s
      @grid.map do |row|
        row.map do |tree|
          tree.height.to_s
        end.join
      end.join("\n")
    end
    
    # Given a cell [row, col], calculates a visibility score which is 
    # how many trees are visible (shorter than this tree) in a particular
    # direction.  Total score for a tree is n * w * e * s.  And I'm not
    # proud of this code, but it works.
    def visibility_score(row, col)
      z = @grid[row][col].height
      width = @grid[0].size
      height = @grid.size
      dir_total = 0
      total = 1

      # Look North
      (0...row).reverse_each do |i|
        dir_total += 1
        if @grid[i][col].height >= z
          break
        end
      end
      total *= dir_total
      dir_total = 0

      # Look South
      ((row+1)...height).each do |i|
        dir_total += 1
        if @grid[i][col].height >= z
          break
        end
      end
      total *= dir_total
      dir_total = 0

      # Look West
      (0...col).reverse_each do |j|
        dir_total += 1
        if @grid[row][j].height >= z
          break
        end
      end
      total *= dir_total
      dir_total = 0

      # Look East
      ((col+1)...width).each do |j|
        dir_total += 1
        if @grid[row][j].height >= z
          break
        end
      end
      total *= dir_total
      total
    end
    
    # Figure out the best possible visibility score in the grid.
    # But, mysteriously, not which tree provides it.
    def best_visibility
      @grid.map_with_index do |row, i|
        row.map_with_index do |_, j|
          visibility_score(i, j)
        end.max
      end.max
    end
  end

  def self.part1(filename)
    forest = Forest.from_file(filename)
    forest.detect_visibility
    forest.count_visible
  end

  def self.part2(filename)
    forest = Forest.from_file(filename)
    forest.best_visibility
  end

  def self.main(filename)
    puts "Day 8:"
    puts "Part 1: #{part1(filename)}"
    puts "Part 2: #{part2(filename)}"
    puts "=" * 40
  end
end