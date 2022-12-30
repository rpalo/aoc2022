# Day 17: Pyroclastic Flow
# 
# Part 1: Figure out how tall tetris-shaped rocks stack
# 
# Part 2: Figure out how 1_000_000_000_000 rocks stack
module Day17
  class Rock
    enum RockType
      Minus
      Plus
      L
      Pipe
      Box
    end

    getter kind : RockType
    getter width : Int32
    getter height : Int32

    def initialize(@kind, @width, @height)
    end

    def self.minus
      Rock.new(RockType::Minus, 4, 1)
    end

    def self.plus
      Rock.new(RockType::Plus, 3, 3)
    end

    def self.l
      Rock.new(RockType::L, 3, 3)
    end

    def self.pipe
      Rock.new(RockType::Pipe, 1, 4)
    end

    def self.box
      Rock.new(RockType::Box, 2, 2)
    end

    class Shapes
      include Iterator(Rock)

      getter i : Int32
      
      def initialize
        @i = 0
      end

      def next
        result = case @i
          when 0 
            Rock.minus
          when 1
             Rock.plus
          when 2
            Rock.l
          when 3
            Rock.pipe
          when 4
            Rock.box
          else
            raise "Rock Shapes is broken."
        end

        @i = (@i + 1) % 5
        result
      end
    end
  end

  class Cavern
    CAVERN_WIDTH = 7
    @vents : Iterator(Char)
    @grid : Array(Array(Bool))
    @rock_factory : Rock::Shapes

    getter rock_factory : Rock::Shapes

    def initialize(@vents)
      @grid = [
        Array.new(CAVERN_WIDTH, false),
        Array.new(CAVERN_WIDTH, false),
        Array.new(CAVERN_WIDTH, false),
        Array.new(CAVERN_WIDTH, false)
      ]
      @rock_factory = Rock::Shapes.new
    end

    def drop_rock!
      new_rock = @rock_factory.next
      x = 2
      y = highest + 4

      loop do
        direction = @vents.next
        if direction == '>' && can_blow(new_rock, x, y, direction)
          x += 1
        elsif direction == '<' && can_blow(new_rock, x, y, direction)
          x -= 1
        end

        if can_go_down(new_rock, x, y)
          y -= 1
        else
          cement!(new_rock, x, y)
          # print_self
          break
        end
      end
    end

    def can_blow(rock, x, y, direction)
      if direction == '<' && x == 0
        return false
      elsif direction == '>' && x + rock.width >= CAVERN_WIDTH
        return false
      elsif y > highest
        return true
      end
      
      real_y = @grid.size - y

      if direction == '<'
        case rock.kind
        when Rock::RockType::Minus
          !@grid[real_y][x - 1]
        when Rock::RockType::Plus
          !(
            @grid[real_y - 2][x] ||
            @grid[real_y - 1][x - 1] ||
            @grid[real_y][x]
          )
        when Rock::RockType::L
          !(
            @grid[real_y - 2][x + 1] ||
            @grid[real_y - 1][x + 1] ||
            @grid[real_y][x - 1]
          )
        when Rock::RockType::Pipe
          !(
            @grid[real_y - 3][x - 1] ||
            @grid[real_y - 2][x - 1] ||
            @grid[real_y - 1][x - 1] ||
            @grid[real_y][x - 1]
          )
        when Rock::RockType::Box
          !(
            @grid[real_y - 1][x - 1] ||
            @grid[real_y][x - 1]
          )
        end
      else
        case rock.kind
        when Rock::RockType::Minus
          !@grid[real_y][x + 4]
        when Rock::RockType::Plus
          !(
            @grid[real_y - 2][x + 2] ||
            @grid[real_y - 1][x + 3] ||
            @grid[real_y][x + 2]
          )
        when Rock::RockType::L
          !(
            @grid[real_y - 2][x + 3] ||
            @grid[real_y - 1][x + 3] ||
            @grid[real_y][x + 3]
          )
        when Rock::RockType::Pipe
          !(
            @grid[real_y - 3][x + 1] ||
            @grid[real_y - 2][x + 1] ||
            @grid[real_y - 1][x + 1] ||
            @grid[real_y][x + 1]
          )
        when Rock::RockType::Box
          !(
            @grid[real_y - 1][x + 2] ||
            @grid[real_y][x + 2]
          )
        end
      end
    end

    def can_go_down(rock, x, y)
      if y > highest + 1
        return true
      end
      return false if y == 1

      real_y = @grid.size - y
      case rock.kind
      when Rock::RockType::Minus
        !(
          @grid[real_y + 1][x] ||
          @grid[real_y + 1][x + 1] ||
          @grid[real_y + 1][x + 2] ||
          @grid[real_y + 1][x + 3]
        )
      when Rock::RockType::Plus
        !(
          @grid[real_y][x] ||
          @grid[real_y + 1][x + 1] ||
          @grid[real_y][x + 2]
        )
      when Rock::RockType::L
        !(
          @grid[real_y + 1][x] ||
          @grid[real_y + 1][x + 1] ||
          @grid[real_y + 1][x + 2]
        )
      when Rock::RockType::Pipe
        !@grid[real_y + 1][x]
      when Rock::RockType::Box
        !(
          @grid[real_y + 1][x] ||
          @grid[real_y + 1][x + 1]
        )
      end
    end

    def cement!(rock, x, y)
      real_y = @grid.size - y

      case rock.kind
      when Rock::RockType::Minus
        @grid[real_y][x, rock.width] = [true, true, true, true]
      when Rock::RockType::Plus
        @grid[real_y - 2][x + 1] = true
        @grid[real_y - 1][x, rock.width] = [true, true, true]
        @grid[real_y][x + 1] = true
      when Rock::RockType::L
        @grid[real_y - 2][x + 2] = true
        @grid[real_y - 1][x + 2] = true
        @grid[real_y][x, rock.width] = [true, true, true]
      when Rock::RockType::Pipe
        @grid[real_y - 3][x] = true
        @grid[real_y - 2][x] = true
        @grid[real_y - 1][x] = true
        @grid[real_y][x] = true
      when Rock::RockType::Box
        @grid[real_y - 1][x, rock.width] = [true, true]
        @grid[real_y][x, rock.width] = [true, true]
      end
      rock.height.times {@grid.insert(0, Array.new(CAVERN_WIDTH, false))}
    end

    def highest
      @grid.each_with_index do |row, i|
        return @grid.size - i if row.any?
      end
      0
    end

    def print_self
      print('\n')
      @grid.each do |row|
        row.each do |val|
          val ? print('#') : print('.')
        end
        print('\n')
      end
    end
  end

  class Vents
    include Iterator(Char)

    @chars : Array(Char)

    getter i : Int32

    def initialize(@chars)
      @i = 0
    end

    def next
      c = @chars[@i]
      @i = (@i + 1) % @chars.size
      c
    end
  end

  def self.part1(filename)
    vents = File.read(filename).chars.cycle
    cavern = Cavern.new(vents)
    2022.times do 
      cavern.drop_rock!
    end
    cavern.highest
  end

  def self.part2(filename)
    chars = File.read(filename).chars
    vents = Vents.new(chars)
    cavern = Cavern.new(vents)
    i = 0
    start_loop = -1
    heights = [] of Int32
    start_indices = [] of Int32
    start_index = -1
    end_loop = -1
    loop do
      if i != 0 && start_indices.includes?(vents.i) && cavern.rock_factory.i == 0 && start_loop == -1
        start_loop = i
        start_index = vents.i
        heights << cavern.highest
      elsif start_loop != -1 && start_index == vents.i
        end_loop = i
        break
      end

      if start_loop == -1 && cavern.rock_factory.i == 0
        start_indices << vents.i
      end

      cavern.drop_rock!
      if start_loop != -1
        heights << cavern.highest
      end
      i += 1 
    end

    puts "#{start_loop}, #{end_loop}, #{heights}"

    loop_height = heights[-1] - heights[0]
    puts loop_height
    puts end_loop - start_loop
    whole_loops = (1_000_000_000_000 - start_loop.to_i64 - 1_i64) // (end_loop.to_i64 - start_loop.to_i64)
    partial_i = (1_000_000_000_000 - start_loop.to_i64) % (end_loop.to_i64 - start_loop.to_i64)
    height = loop_height.to_i64 * whole_loops.to_i64 + heights[partial_i].to_i64
    height
  end

  def self.main(filename)
    puts "Day 17:"
    puts "Part 1: #{part1(filename)}"
    puts "Part 2: #{part2(filename)}"
    puts "=" * 40
  end
end

