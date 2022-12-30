require "./spec_helper"

describe Day6 do
  describe "#find_start_of_packet" do
    it "should find the start-of-packet marker" do
      Day6.find_start_of_packet("mjqjpqmgbljsphdztnvjfqwrcgsmlb").should eq(7)
      Day6.find_start_of_packet("bvwbjplbgvbhsrlpgdmjqwftvncz").should eq(5)
      Day6.find_start_of_packet("nppdvjthqldpwncqszvftbrmjlhg").should eq(6)
      Day6.find_start_of_packet("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg").should eq(10)
      Day6.find_start_of_packet("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw").should eq(11)
    end
  end

  describe "#find_start_of_message" do
    it "should find the start-of-message marker" do
      Day6.find_start_of_message("mjqjpqmgbljsphdztnvjfqwrcgsmlb").should eq(19)
      Day6.find_start_of_message("bvwbjplbgvbhsrlpgdmjqwftvncz").should eq(23)
      Day6.find_start_of_message("nppdvjthqldpwncqszvftbrmjlhg").should eq(23)
      Day6.find_start_of_message("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg").should eq(29)
      Day6.find_start_of_message("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw").should eq(26)
    end
  end
end