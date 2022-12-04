# Day 3: Rucksack Reoganization
# 
# Part 1: Find the priority of the char that appears in the first and 
# second half of the line
# 
# Part 2: Find the priority of the item shared by each 3 consecutive lines
module Day3
  PRIORITIES = ('a'..'z').to_a + ('A'..'Z').to_a

  def self.priority(c)
    (PRIORITIES.index(c) || 0) + 1
  end

  def self.dual_filed_priority(s)
    side_size = s.size // 2
    left_chars = s[...side_size].chars.to_set
    right_chars = s[side_size..].chars.to_set
    dup = (left_chars & right_chars).to_a[0]
    priority(dup)
  end

  def self.part1(filename)
    File.read_lines(filename).sum {|line| dual_filed_priority(line)}
  end

  def self.part2(filename)
    File.read_lines(filename).each_slice(3).sum do |group|
      badge = group[1..]
        .reduce(group[0].chars.to_set) { |acc, line| acc &= line.chars.to_set }
        .to_a.first
      priority(badge)
    end
  end

  def self.main(filename)
    puts "Day 3:"
    puts "Part 1: Total misfiled priority scores: #{part1(filename)}"
    puts "Part 2: Total badge priorities: #{part2(filename)}"
    puts "=" * 40
  end
end