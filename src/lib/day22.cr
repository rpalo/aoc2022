require "string_scanner"
# Day 21: Monkey Map
# 
# Part 1: Follow instructions to walk like pacman through a map with walls
# 
# Part 2: 
module Day22
  class Guy
    @map : Array(String)
    getter x : Int32
    getter y : Int32
    getter facing : Int32

    STEPS = [{1, 0}, {0, 1}, {-1, 0}, {0, -1}]

    def initialize(@x, @y, @facing, @map)
    end

    def follow(instructions)
      s = StringScanner.new(instructions)
      while !s.eos?
        # output
        if s.scan(/\d+/)
          # puts "Forward #{s[0]}"
          forward(s[0].to_i)
        elsif s.scan(/R/)
          # puts "Turn Right"
          @facing = (@facing + 1) % 4
          # puts @facing
        elsif s.scan(/L/)
          # puts "Turn Left"
          @facing = (@facing - 1) % 4
          # puts @facing
        end
      end
    end

    def forward(n)
      dx, dy = STEPS[@facing]
      n.times do
        new_x, new_y = @x + dx, @y + dy
        if (new_x >= @map[0].size || new_x < 0 || 
            new_y >= @map.size || new_y < 0 ||
            @map[new_y][new_x] == ' '
        )
          new_x, new_y = @x, @y
          while ((dx == -1 && new_x < @map[0].size - 1) ||
                 (dx == 1 && new_x > 0) ||
                 (dy == -1 && new_y < @map.size - 1) ||
                 (dy == 1 && new_y > 0)) &&
                 @map[new_y - dy][new_x - dx] != ' '
            new_x -= dx
            new_y -= dy
          end
        end
  
        if @map[new_y][new_x] == '#'
          break
        end
        @x, @y = new_x, new_y
        # output
      end
    end

    def output
      puts
      @map.each_with_index do |row, j|
        row.chars.each_with_index do |c, i|
          if i == @x && j == @y
            print ">v<^"[@facing]
          else
            print c
          end
        end
        print "\n"
      end
    end
  end

  def self.parse(filename)
    map_str, instructions = File.read(filename).split("\n\n")
    map = map_str.split("\n")
    widest = map.max_of(&.size)
    map = map.map do |line|
      if line.size < widest
        line + " " * (widest - line.size)
      else
        line
      end
    end
    
    x = map[0].index(".").as(Int32)
    y = 0
    guy = Guy.new(x, y, 0, map)
    {guy, instructions}
  end

  class Face
    getter grid : Array(String)
    property mappings : Array(Tuple(Face, Bool, Int32))

    def initialize(@grid)
      @mappings = Array(Tuple(Face, Bool, Int32)).new
    end

    def blocked?(direction, i)
      face, is_flipped, new_dir = @mappings[direction]
      if is_flipped
        i = @grid.size - i
      end
      case new_dir
      when 0
        face.grid[i][0] == '#'
      when 1
        face.grid[0][i] == '#'
      when 2
        face.grid[i][-1] == '#'
      when 3
        face.grid[-1][i] == '#'
      else
        raise "Blocked error"
      end
    end

    def transfer(direction, i)
      face, is_flipped, new_dir = @mappings[direction]
      if is_flipped
        i = @grid.size - i
      end
      case new_dir
      when 0
        {face, 0, i, new_dir}
      when 1
        {face, i, 0, new_dir}
      when 2
        {face, @grid.size - 1, i, new_dir}
      when 3
        {face, i, @grid.size - 1, new_dir}
      else
        raise "Transfer error"
      end
    end
  end

  def self.special_parse(filename)
    map_str, instructions = File.read(filename).split("\n\n")
    map = map_str.split("\n").map(&.strip)
    face1 = Face.new(map[...50].map(&.[...50]))
    face2 = Face.new(map[...50].map(&.[50..]))
    face3 = Face.new(map[50...100])
    face4 = Face.new(map[100...150][...50])
    face5 = Face.new(map[100...150][50..])
    face6 = Face.new(map6 = map[150..])

    #  12
    #  3
    # 45
    # 6

    # 2 v == 3 >
    # 2 > == 5 >
    # 2 ^ == 6 v
    # 1 ^ == 6 <
    # 1 < == 4 <
    # 3 < == 4 ^
    # 5 v == 6 >

    # Mapping is {Face, is_flipped_index, direction_upon_arrival}

    face1.mappings = [
      {face2, false, 0},
      {face3, false, 1},
      {face4, true, 0},
      {face6, false, 0}
    ]
    face2.mappings = [
      {face5, true, 2},
      {face3, false, 2},
      {face1, false, 2},
      {face6, false, 3}
    ]
    face3.mappings = [
      {face2, false, 3},
      {face5, false, 1},
      {face4, false, 2},
      {face1, false, 3}
    ]
    face4.mappings = [
      {face5, false, 0},
      {face6, false, 1},
      {face1, true, 0},
      {face3, false, 0}
    ]
    face5.mappings = [
      {face2, true, 2},
      {face6, false, 2},
      {face4, false, 2},
      {face3, false, 3}
    ]
    face6.mappings = [
      {face5, false, 3},
      {face2, false, 1},
      {face1, false, 1},
      {face4, false, 3}
    ]

    x = face1.grid[0].index(".").as(Int32)
    guy = CubeGuy.new(x, 0, 0, face1)
    {guy, instructions}
  end

  class CubeGuy
    @face : Face
    getter x : Int32
    getter y : Int32
    getter facing : Int32

    def initialize(@x, @y, @facing, @face)
    end

    def follow(instructions)
      s = StringScanner.new(instructions)
      while !s.eos?
        # output
        if s.scan(/\d+/)
          # puts "Forward #{s[0]}"
          forward(s[0].to_i)
        elsif s.scan(/R/)
          # puts "Turn Right"
          @facing = (@facing + 1) % 4
          # puts @facing
        elsif s.scan(/L/)
          # puts "Turn Left"
          @facing = (@facing - 1) % 4
          # puts @facing
        end
      end
    end

    def forward(n)
      n.times do
        case facing
        when 0
          if @x == @face.grid[0].size - 1
            if @face.blocked?(0, @y)
              break
            end

            @face, @x, @y, @facing = @face.transfer(0, @y)
          else
            @x += 1
          end
        when 1
          if @y == @face.grid.size - 1
            if @face.blocked?(1, @x)
              break
            end

            @face, @x, @y, @facing = @face.transfer(1, @x)
          else
            @y += 1
          end
        when 2
          if @x == 0
            if @face.blocked?(2, @y)
              break
            end

            @face, @x, @y, @facing = @face.transfer(2, @y)
          else
            @x -= 1
          end
        when 3
          if @y == 0
            if @face.blocked?(3, @x)
              break
            end

            @face, @x, @y, @facing = @face.transfer(3, @x)
          else
            @y -= 1
          end
        end
      end
    end

    def output
      puts
      @map.each_with_index do |row, j|
        row.chars.each_with_index do |c, i|
          if i == @x && j == @y
            print ">v<^"[@facing]
          else
            print c
          end
        end
        print "\n"
      end
    end
  end


  def self.part1(filename)
    guy, instructions = parse(filename)
    guy.follow(instructions)
    1000 * (guy.y + 1) + 4 * (guy.x + 1) + guy.facing  
  end

  def self.part2(filename)
    guy, instructions = special_parse(filename)
    guy.follow(instructions)
    1000 * (guy.y + 1) + 4 * (guy.x + 1) + guy.facing  
  end

  def self.main(filename)
    puts "Day 22:"
    puts "Part 1: #{part1(filename)}"
    puts "Part 2: #{part2(filename)}"
    puts "=" * 40
  end
end
