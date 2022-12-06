# Day 6: Tuning Trouble 
# 
# Part 1: Count the characters before the start-of-packet marker, 4 chars
#   that are all different, is encountered.
# 
# Part 2: Do Part 1, but looking for the start-of-message marker, which 
#   is *14* unique chars in a row.
module Day6
  def self.find_start_of_packet(data)
    find_marker(data, 4)
  end

  def self.find_start_of_message(data)
    find_marker(data, 14)
  end

  def self.find_marker(data, size)
    data.chars.each_cons(size).each_with_index(size) do |s, i|
      return i if s.to_set.size == size
    end
    raise "Couldn't find the marker"
  end

  def self.main(filename)
    puts "Day 6:"
    data = File.read(filename)
    puts "Part 1: #{find_start_of_packet(data)}"
    puts "Part 2: #{find_start_of_message(data)}"
    puts "=" * 40
  end
end