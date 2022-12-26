# Day 21: Monkey Math
# 
# Part 1: Calculate the result of a bunch of monkey math
# 
# Part 2: the humn monkey is you, and root's operation is ==.  What
#   number do you need to say to make root's equation true?
module Day21
  # Parse the file into a Hash of names to either Ints or procs that
  # will eventually create Ints.  In this way, cache the result of a
  # particular monkey once they've declared their value.
  def self.parse(filename)
    monkeys = Hash(String, Int64 | -> Int64).new
    File.each_line(filename) do |line|
      name, rest = line.split(": ")
      if rest =~ /[0-9]+/
        monkeys[name] = rest.to_i64
      else
        first, op, second = rest.split
        monkeys[name] = -> {compute(first, op, second, monkeys)}
      end
    end
    monkeys
  end

  # Cache a monkey's declared value to avoid fibonacci-like recursive
  # performance issues.
  def self.compute(name, monkeys)
    result = monkeys[name].as(->Int64).call
    monkeys[name] = result
    result
  end

  # Make sure a and b are cached and then calc the result.
  def self.compute(a, op, b, monkeys)
    if !monkeys[a].is_a?(Int64)
      compute(a, monkeys)
    end

    if !monkeys[b].is_a?(Int64)
      compute(b, monkeys)
    end

    case op
    when "+"
      monkeys[a].as(Int64) + monkeys[b].as(Int64)
    when "-"
      monkeys[a].as(Int64) - monkeys[b].as(Int64)
    when "*"
      monkeys[a].as(Int64) * monkeys[b].as(Int64)
    when "/"
      monkeys[a].as(Int64) // monkeys[b].as(Int64)
    else
      raise "Bad operator"
    end
  end

  def self.part1(filename)
    monkeys = parse(filename)
    compute("root", monkeys)
  end

  # For Part 2, operations need to have references to their children
  # so we can invert the operation tree to "solve for" humn.
  # 
  # If a Monkey has a raw integer value, store that in Num and
  # *@op*, *@left*, and *@right* will be nil.  Otherwise, *@num* starts
  # out nil, but can be set as an `Operation` calculates its value
  # and caches itself.
  class Operation
    @name: String
    @op : String?
    @left : Operation?
    @right: Operation?
    @num : Int64?

    getter name
    getter left
    getter right
    getter op
    
    def initialize(@name, @op = nil, @left = nil, @right = nil, @num = nil)
    end

    # True if self or any child is "humn"
    def contains_human?
      @name == "humn" || 
      (!@left.nil? && @left.as(Operation).contains_human?) ||
      (!@right.nil? && @right.as(Operation).contains_human?)
    end

    # Calculate self's value based on children values.  Cache it.
    def value
      return @num.as(Int64) if !@num.nil?
      
      result = case @op
               when "+"
                @left.as(Operation).value + @right.as(Operation).value
               when "-"
                @left.as(Operation).value - @right.as(Operation).value
               when "*"
                @left.as(Operation).value * @right.as(Operation).value
               when "/"
                @left.as(Operation).value // @right.as(Operation).value
               when "sub&invert"
                -(@left.as(Operation).value - @right.as(Operation).value)
               when "flipdiv"
                @right.as(Operation).value // @left.as(Operation).value
               else
                raise "Bad op."
               end
      @num = result
      result
    end
  end

  # Now, output a Hash of name => Operation pairs.
  # A bit of looping is needed to ensure dependency Monkeys are defined
  # before the ones that call them can be defined.
  def self.parse2(filename)
    monkeys = Hash(String, Operation).new
    pending = Array(Tuple(String, String, String, String)).new
    File.each_line(filename) do |line|
      name, rest = line.split(": ")
      if rest =~ /[0-9]+/
        monkeys[name] = Operation.new(name, num: rest.to_i64)
      else
        first, op, second = rest.split
        if monkeys.includes?(first) && monkeys.includes?(second)
          monkeys[name] = Operation.new(name, op: op, left: monkeys[first], right: monkeys[second])
        else
          pending << {name, first, op, second}
        end
      end
    end

    while !pending.empty?
      name, first, op, second = pending.shift
      if monkeys.keys.includes?(first) && monkeys.keys.includes?(second)
        monkeys[name] = Operation.new(name, op: op, left: monkeys[first], right: monkeys[second])
      else
        pending.push({name, first, op, second})
      end
    end
    
    monkeys
  end

  # Key is op, Value is the op that undoes *key* assuming you want to
  # keep the LEFT value.
  RIGHT_OPPOSITE_OPS = {
    "+" => "-",
    "-" => "+",
    "*" => "/",
    "/" => "*"
  }

  # Key is op, Value is the op that undoes *key* assuming you want to
  # keep the RIGHT value.  Note that sub&invert and flipdiv are new
  # "operators" that perform 2 "operations" in one to maintain which
  # side of the equation "humn" is on.
  # 
  # sub&invert subtracts the LEFT positive value away and then multiplies
  # both sides by -1 to ensure the RIGHT operand on the left side of the
  # == remains positive.
  # 
  # flipdiv is the same for division: divide the LEFT operand away
  # and then take the reciprocal of both sides to ensure the left side
  # of the == is in the numerator.
  LEFT_OPPOSITE_OPS = {
    "+" => "-",
    "-" => "sub&invert",
    "*" => "/",
    "/" => "flipdiv"
  }

  # 1. Figure out which side of ROOT "humn" is on.
  # 2. For that side, piece by piece, algebraically undo operations to
  #   "unwrap" the "humn" variable and "solve" for it, systematically
  #   modifying the opposite side of the == to maintain equality.
  # 3. Once "humn" has been isolated, evaluate the opposite side of the
  #   equation.
  def self.part2(filename)
    monkeys = parse2(filename)
    root = monkeys["root"]
    if root.left.as(Operation).contains_human?
      num_side = root.right.as(Operation)
      var_side = root.left.as(Operation)
    else
      num_side = root.left.as(Operation)
      var_side = root.right.as(Operation)
    end

    while var_side.name != "humn"
      if var_side.left.as(Operation).contains_human?
        num_side = Operation.new(
          name: "undo-#{var_side.name}",
          op: RIGHT_OPPOSITE_OPS[var_side.op],
          left: num_side,
          right: Operation.new(name: var_side.right.as(Operation).name, num: var_side.right.as(Operation).value)
        )
        var_side = var_side.left.as(Operation)
      else
        num_side = Operation.new(
          name: "undo-#{var_side.name}",
          op: LEFT_OPPOSITE_OPS[var_side.op],
          left: num_side,
          right: Operation.new(name: var_side.left.as(Operation).name, num: var_side.left.as(Operation).value)
        )
        var_side = var_side.right.as(Operation)
      end
    end
    num_side.value
  end

  def self.main(filename)
    puts "Day 21:"
    puts "Part 1: #{part1(filename)}"
    puts "Part 2: #{part2(filename)}"
    puts "=" * 40
  end
end

