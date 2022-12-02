# Day 2: Rock Paper Scissors
# 
# Part 1:
# Calculate scored rounds of rock paper scissors.
# A and X = Rock, B and Y = Paper, C and Z = Scissors
# 
# Part 2:
# X = Lose, Y = Tie, Z = Win
# 
# 3 points for tie, 6 points for win, 0 points for loss
# 1 point for playing rock, 2 points for paper, 3 for scissors
class Day2
  def sum_rounds(filename)
    File.read_lines(filename).sum do |line|
      score(line[0], line[2])
    end
  end

  def sum_rounds2(filename)
    File.read_lines(filename).sum do |line|
      score2(line[0], line[2])
    end
  end

  def score(opponent, you)
    points = case you
    when 'X'
      1
    when 'Y'
      2
    when 'Z'
      3
    else
      0
    end

    if (
      you == 'X' && opponent == 'A' ||
      you == 'Y' && opponent == 'B' ||
      you == 'Z' && opponent == 'C'
    )
      points += 3
    elsif (
      you == 'X' && opponent == 'C' ||
      you == 'Y' && opponent == 'A' ||
      you == 'Z' && opponent == 'B'
    )
      points += 6
    end
    points
  end

  def score2(opponent, outcome)
    if outcome == 'X' # lose
      if opponent == 'A'
        3 # scissors, lose
      elsif opponent == 'B'
        1 # rock, lose
      else
        2 # paper, lose
      end
    elsif outcome == 'Y'  # tie
      if opponent == 'A'
        4 # rock, tie
      elsif opponent == 'B'
        5 # paper, tie
      else
        6 # scissors, tie
      end
    else  # win
      if opponent == 'A'
        8 # paper, win
      elsif opponent == 'B'
        9 # scissors, win
      else
        7 # rock, win
      end
    end
  end
  
  def main(filename)
    puts "Part 1: #{sum_rounds(filename)}"
    puts "Part 2: #{sum_rounds2(filename)}"
  end
end