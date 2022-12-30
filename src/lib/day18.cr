# Day 18: Boiling Boulders
# 
# Part 1: Calculate the surface area of a 3D cube grid.  Adjacent faces
#   touching each other merge into a solid.
# 
# Part 2: Ignore internal surface area, what is the external surface
#   area (accessible from the outside)
module Day18
  # Parses the file into x, y, z integer triplets
  def self.parse(filename)
    File.read_lines(filename).map do |line|
      x, y, z = line.split(",").map(&.to_i)
      {x, y, z}
    end.to_set
  end

  # Calculate total surface area by adding at most 6 for any given
  # additional cube.  But reduce by 2 for every adjacent face that
  # exists on a cube we've already processed.
  def self.surface_area(cubes)
    seen = Set(Tuple(Int32, Int32, Int32)).new
    total_sides = 0
    cubes.each do |cube|
      x, y, z = cube
      open_sides = 6
      if seen.includes?({x + 1, y, z})
        open_sides -= 1
        total_sides -= 1
      end
      if seen.includes?({x - 1, y, z})
        open_sides -= 1
        total_sides -= 1
      end
      if seen.includes?({x, y + 1, z})
        open_sides -= 1
        total_sides -= 1
      end
      if seen.includes?({x, y - 1, z})
        open_sides -= 1
        total_sides -= 1
      end
      if seen.includes?({x, y, z + 1})
        open_sides -= 1
        total_sides -= 1
      end
      if seen.includes?({x, y, z - 1})
        open_sides -= 1
        total_sides -= 1
      end
      seen << {x, y, z}
      total_sides += open_sides
    end
    total_sides
  end

  def self.part1(filename)
    cubes = parse(filename)
    surface_area(cubes)
  end

  def self.bounds(cubes)
    x_max = cubes.max_of(&.[0]) + 3
    y_max = cubes.max_of(&.[1]) + 3
    z_max = cubes.max_of(&.[2]) + 3
    {x_max, y_max, z_max}
  end

  # Explore the outer surface and count each external face exactly once.
  def self.outer_surface_area(cubes)
    x_max, y_max, z_max = bounds(cubes)
    seen = Set(Tuple(Int32, Int32, Int32)).new
    queue = Array(Tuple(Int32, Int32, Int32)).new
    queue << {0, 0, 0}
    area = 0
    while !queue.empty?
      current = queue.shift
      next if seen.includes?(current)
      seen << current
      x, y, z = current

      if !cubes.includes?({x + 1, y, z}) && !seen.includes?({x + 1, y, z}) && x + 1 <= x_max
        queue << {x + 1, y, z}
      elsif cubes.includes?({x + 1, y, z})
        area += 1
      end
      if !cubes.includes?({x - 1, y, z}) && !seen.includes?({x - 1, y, z}) && x - 1 >= -1
        queue << {x - 1, y, z}
      elsif cubes.includes?({x - 1, y, z})
        area += 1
      end
      if !cubes.includes?({x, y + 1, z}) && !seen.includes?({x, y + 1, z}) && y + 1 <= y_max
        queue << {x, y + 1, z}
      elsif cubes.includes?({x, y + 1, z})
        area += 1
      end
      if !cubes.includes?({x, y - 1, z}) && !seen.includes?({x, y - 1, z}) && y - 1 >= -1
        queue << {x, y - 1, z}
      elsif cubes.includes?({x, y - 1, z})
        area += 1
      end
      if !cubes.includes?({x, y, z + 1}) && !seen.includes?({x, y, z + 1}) && z + 1 <= z_max
        queue << {x, y, z + 1}
      elsif cubes.includes?({x, y, z + 1})
        area += 1
      end
      if !cubes.includes?({x, y, z - 1}) && !seen.includes?({x, y, z - 1}) && z - 1 >= -1
        queue << {x, y, z - 1}
      elsif cubes.includes?({x, y, z - 1})
        area += 1
      end
    end
    area
  end

  def self.part2(filename)
    cubes = parse(filename)
    outer_surface_area(cubes)
  end

  def self.main(filename)
    puts "Day 18:"
    puts "Part 1: #{part1(filename)}"
    puts "Part 2: #{part2(filename)}"
    puts "=" * 40
  end
end

