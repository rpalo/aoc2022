# Day 19: Not Enough Minerals
# 
# Part 1: Figure out how many geodes you can make with each blueprint
# 
# Part 2: 
module Day19
  enum Material
    ORE
    CLAY
    OB
    GEODE
  end

  class State
    @robits : Array(Int32)
    @materials : Array(Int32)
    @costs : Array(Array(Int32))
    @t : Int32
    @factory : Material?

    def initialize(@robits, @materials, @costs, @t, @factory)
    end

    def neighbors
      new_materials = @materials.dup
      if !@factory.nil?
        costs = @costs[@factory.as(Material).value]
        costs.each_with_index do |c, i|
          new_materials[i] -= c
        end
      end
      @robits.each_with_index do |robit, i|
        new_materials[i] += robit
      end
      new_robits = @robits.dup
      if !@factory.nil?
        new_robits[@factory.as(Material).value] += 1
      end
      possible_choices = Material.values.select do |m|
        @costs[m.value].zip(new_materials).all? { |cost, stock| stock >= cost }
      end
      nexts = possible_choices.map do |material|
        State.new(
          robits: new_robits.dup,
          materials: new_materials.dup,
          costs: @costs,
          t: @t + 1,
          factory: material
        )
      end
      
      if nexts.size < 4
        nexts << State.new(
          robits: new_robits.dup,
          materials: new_materials.dup,
          costs: @costs,
          t: @t + 1,
          factory: nil
        )
      end
      nexts
    end

    def score
      @materials[0] * 1 +
      @materials[1] * 1 +
      @materials[2] * 2 +
      @materials[3] * 10 +
      @robits[0] * 5 +
      @robits[1] * 4 +
      @robits[2] * 20 +
      @robits[3] * 100
    end

    def to_s
      "Robits: #{@robits}, Minerals: #{@materials}"
    end

    def geodes
      @materials[Material::GEODE.value]
    end
  end

  def self.simulate(start_state)
    options = [start_state]
    24.times do |i|
      options = options.flat_map { |state| state.neighbors }
        .sort_by(&.score).reverse.first(10000)
      puts options[0].to_s
    end
    options.max_of { |state| state.geodes }
  end

  def self.part1(filename)
    File.read_lines(filename).reduce(0) do |acc, line|
      nums = line.scan(/\d+/).map(&.[0].to_i)
      puts nums
      id = nums[0]
      start_state = State.new(
        robits: [1, 0, 0, 0],
        materials: [0, 0, 0, 0],
        costs: [
          [nums[1], 0, 0, 0],
          [nums[2], 0, 0, 0],
          [nums[3], nums[4], 0, 0],
          [nums[5], 0, nums[6], 0]
        ],
        t: 0,
        factory: nil
      )
      best_score = simulate(start_state)
      puts id, best_score
      acc + best_score * id
    end
  end

  def self.part2(filename)
  
  end

  def self.main(filename)
    puts "Day 19:"
    puts "Part 1: #{part1(filename)}"
    puts "Part 2: #{part2(filename)}"
    puts "=" * 40
  end
end

