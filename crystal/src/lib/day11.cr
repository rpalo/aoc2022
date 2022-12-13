require "big"
require "string_scanner"
# Day 11: Monkey in the Middle
# 
# Part 1: Discover which monkeys are the most active inspectors.
#   Calculated in units of 'monkey business'
# 
# Part 2:
module Day11
  class Monkey
    @items : Array(BigInt)
    @operation : Proc(BigInt, BigInt)
    @test : BigInt
    @true_target : Int32
    @false_target : Int32
    
    property items
    property monkeys
    getter inspections

    def initialize(@items, @operation, @test, @true_target, @false_target)
      @inspections = 0
      @monkeys = Array(Monkey).new
    end

    def act
      while !@items.empty?
        @inspections += 1
        item = @items.shift
        item = @operation.call(item)
        item //= 3
        if item % @test == 0
          @monkeys[@true_target].items << item
        else
          @monkeys[@false_target].items << item
        end
      end
    end

    def act_without_relief
      while !@items.empty?
        @inspections += 1
        item = @items.shift
        item = @operation.call(item)
        if item % @test == 0
          @monkeys[@true_target].items << item
        else
          @monkeys[@false_target].items << item
        end
      end
    end

    def self.parse(paragraph)
      scanner = StringScanner.new(paragraph)
      scanner.skip_until(/items: /)
      items = scanner.scan(/\d+(, \d+)*/).as(String).split(", ").map(&.to_big_i)
      scanner.skip_until(/new = old /)
      op, val = scanner.scan(/(\+|\*) (\d+|old)/).as(String).split

      operation = if val == "old" && op == "+"
                    ->(x : BigInt) {x + x}
                  elsif val == "old"
                    ->(x : BigInt) {x * x}
                  elsif op == "+"
                    ->(x : BigInt) {x + val.to_big_i}
                  else
                    ->(x : BigInt) {x * val.to_big_i}
                  end

      scanner.skip_until(/divisible by /)
      test = scanner.scan(/\d+/).as(String).to_big_i
      scanner.skip_until(/monkey /)
      true_target = scanner.scan(/\d+/).as(String).to_i
      scanner.skip_until(/monkey /)
      false_target = scanner.scan(/\d+/).as(String).to_i
      self.new(items, operation, test, true_target, false_target)
    end
  end

  def self.load_monkeys(filename)
    paragraphs = File.read(filename).split("\n\n")
    monkeys = paragraphs.map {|par| Monkey.parse(par)}
    monkeys.each {|monkey| monkey.monkeys = monkeys }
    monkeys
  end

  def self.part1(filename)
    monkeys = load_monkeys(filename)
    20.times { monkeys.each(&.act) }
    monkeys.map(&.inspections).sort.last(2).product
  end

  def self.part2(filename)
    # monkeys = load_monkeys(filename)
    # 1000.times do |i|
    #   monkeys.each(&.act_without_relief)
    #   puts "#{i}, #{monkeys.map(&.inspections).join(",")}"
    # end
    # monkeys.map(&.inspections).sort.last(2).product
  end

  def self.main(filename)
    puts "Day 11:"
    puts "Part 1: #{part1(filename)}"
    puts "Part 2: #{part2(filename)}"
    puts "=" * 40
  end
end