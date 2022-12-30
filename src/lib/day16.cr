# Day 16: Proboscidea Volcanium
# 
# Part 1: Optimize opening valves and travelling through connected tunnels
#   to release the most (ugh) pressures per minute.  For Science.
# 
# Part 2:
module Day16
  # State: Location
  # Neighbors: Move to any tunnel, turn current valve on
  PATTERN = /Valve (?P<name>[A-Z]{2}) has flow rate=(?P<flow>\d+); tunnels? leads? to valves? (?P<neighbors>[A-Z]{2}(, [A-Z]{2})*)/
  class Cave
    property neighbors : Hash(String, Cave)
    getter name : String

    def initialize(@name)
      @neighbors = Hash(String, Cave).new
    end
  end

  class Caves
    property caves : Hash(String, Cave)
    def initialize
      @caves = Hash(String, Cave).new
      @dist_cache = Hash({String, String}, Int32).new
    end

    def [](name)
      @caves[name]
    end

    def []=(name, cave)
      @caves[name] = cave
    end

    def best_path(a : Cave, b : Cave) : Int32
      if @dist_cache.includes?({a.name, b.name})
        return @dist_cache[{a.name, b.name}]
      end

      queue = [{a, 0}]
      seen = Set(String).new
      while !queue.empty?
        current, distance = queue.shift

        seen << current.name
        if current.name == b.name
          @dist_cache[{a.name, b.name}] = distance
          @dist_cache[{b.name, a.name}] = distance
          return distance
        end

        current.neighbors.each do |name, cave|
          next if seen.includes?(name)
          queue << {cave, distance + 1}
        end
      end
      raise "Couldn't find it. #{a.name} -> #{b.name}"
    end
  end

  def self.parse(filename)
    c = Caves.new
    flows = Hash(String, Int32).new

    File.each_line(filename) do |line|
      m = PATTERN.match(line)
      if m.nil?
        raise "mismatch: #{line}"
      end
      if !c.caves.keys.includes?(m["name"])
        c[m["name"]] = Cave.new(m["name"])
      end
      flows[m["name"]] = m["flow"].to_i if m["flow"].to_i > 0
      neighbors = m["neighbors"].split(", ")
      neighbors.each do |neighbor|
        if !c.caves.keys.includes?(neighbor)
          c[neighbor] = Cave.new(neighbor)
        end
        c[neighbor].neighbors[m["name"]] = c[m["name"]]
        c[m["name"]].neighbors[neighbor] = c[neighbor]
      end
    end
    {flows, c}
  end 

  def self.simulate_operation(valve_list, flows, caves)
    position = "AA"
    total = 0
    inc = 0
    time = 30

    valve_list.each do |valve|
      distance = caves.best_path(caves[position], caves[valve])
      position = valve
      change = [distance, time].min 
      time -= change
      total += inc * change
      return total if time <= 0
      time -= 1
      total += inc
      inc += flows[valve]
      return total if time <= 0
    end
    return total + inc * time
  end

  def self.neighbor_states(plan)
    neighbors = [] of Array(String)
    (0...(plan.size - 1)).each do |i|
      plan.swap(i, i + 1)
      neighbors << plan.dup
      plan.swap(i, i + 1)
    end
    neighbors
  end

  def self.simulated_annealing(filename, t, a)
    flows, caves = parse(filename)
    current = flows.keys.sort_by {|valve| -flows[valve] }
    current_score = simulate_operation(current, flows, caves)
    max_encountered = 0

    loop do
      neighbors = neighbor_states(current)
      neighbor = neighbors.sample
      score = simulate_operation(neighbor, flows, caves)
      if score > max_encountered
        max_encountered = score
      end
      if score > current_score
        current_score = score
        current = neighbor
      elsif Math.exp((score - current_score)/(100*t)) > Random.rand
        current_score = score
        current = neighbor
      end
      t *= a
      if t < 0.05
        return max_encountered
      end
    end
  end

  def self.part1(filename)
    # t = 0.88
    # a = 0.88
    # best = 0
    # while t < 1
    #   while a < 1
    #     result = 10.times.max_of {simulated_annealing(filename, t, a)}
    #     puts "#{t}: #{a}: #{result}: #{best}"
    #     if result > best
    #       best = result
    #     end
    #     a += 0.01
    #   end
    #   t += 0.01
    #   a = 0.8
    # end
    # best
  end

  def self.part2(filename)
    
  end

  def self.main(filename)
    puts "Day 16:"
    puts "Part 1: #{part1(filename)}"
    puts "Part 2: #{part2(filename)}"
    puts "=" * 40
  end
end


# Hill climb
# flows, caves = parse(filename)
# current = flows.keys.sort_by {|valve| -flows[valve] }
# current_score = simulate_operation(current, flows, caves)
# loop do
#   puts "#{current}: #{current_score}"
#   neighbors = neighbor_states(current)
#   choice, score = neighbors.map do |neighbor|
#     points = simulate_operation(neighbor, flows, caves)
#     {neighbor, points}
#   end.max_by { |neighbor, points| points }
#   if score <= current_score
#     return current_score
#   end
#   current_score = score
#   current = choice
# end