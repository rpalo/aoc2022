# Day 7: No Space Left on Device
# 
# Part 1: Explore a file tree, add up directory sizes, and find the
#   total size of all the directories whose sizes are <= 100,000
# 
# Part 2: Find the smallest directory which when deleted would leave us
#   with at least 30Mb, given that there is 70Mb total
module Day7
  # Represents a file system file which could be either a directory or
  # file.
  #
  # All FileTrees know about their parent (except "/" who has no parent).
  # FileTrees that are directories have a *name* but their *data_size*
  # is nil.  Directories have a Hash of *children* (name=>FileTree).
  # Files have no children, but have an integer *data_size*.
  #
  # Able to recursively provide a list of the directories they contain
  # (including themselves) via #dirs, the total size of the Files they
  # contain via #size, and children can be added to a FileTree via #<<.
  class FileTree
    @name : String
    @parent : FileTree?
    @data_size : Int32?
    @children : Hash(String, FileTree)

    getter name
    getter parent
    getter data_size
    getter children

    def initialize(name, parent = nil, data_size = nil)
      @name = name
      @parent = parent
      @data_size = data_size
      @children = Hash(String, FileTree).new
    end

    def <<(child)
      @children[child.name] = child
    end

    # Size in b for itself or all of its children.  Directories have no
    # inherent size beyond the sum of their children.
    def size
      if @data_size.nil?
        @children.each_value.sum(&.size)
      else
        @data_size.as(Int32)
      end
    end

    # Returns a list of dirs it contains, including itself.  Thus
    # root.dirs returns a list of all the directories on the filesystem
    def dirs
      if !@data_size.nil?
        return [] of FileTree
      end

      child_dirs = @children.each_value.select {|child| child.data_size.nil?}.to_a
      [self] + child_dirs.map(&.dirs).sum
    end
  end

  # Run through an input file of quasi-shell commands that reveal the
  # filesystem: file and directory names, sizes, and contents.
  # 
  # Makes some assumptions:
  # - A child dir will never be cd-ed into before it has been revealed
  #   via the ls command.
  # - The only possible commands are "cd /", "cd subdir", "cd ..", or "ls"
  # - The script will not attempt to "cd .." from "/" (root).
  # - "ls" is the only command that generates output.
  def self.build_filetree(filename)
    root = FileTree.new("/")
    cwd : FileTree = root
    File.each_line(filename) do |line|
      if line == "$ cd /"
        cwd = root
      elsif line == "$ cd .."
        raise "Root has no parent" if cwd.parent.nil?
        cwd = cwd.parent.as(FileTree)
      elsif line == "$ ls"
        next
      elsif line.starts_with?("$ cd")
        dirname = line.split[-1]
        if !cwd.children.any? { |name, _| name == dirname }
          raise "CD into nonexistent directory #{dirname}"
        end
        cwd = cwd.children[dirname]
      elsif line.starts_with?("dir")
        dirname = line.split[-1]
        cwd << FileTree.new(dirname, cwd)
      else
        size, name = line.split
        size = size.to_i
        cwd << FileTree.new(name, cwd, size)
      end
    end
    root
  end

  # Add up all dirs with sizes <= 100_000
  def self.part1(filename)
    tree = build_filetree(filename)
    tree.dirs.select { |dir| dir.size <= 100_000 }.sum(&.size)
  end

  # Find the smallest dir >= the amount of space needed to increase
  # free space (out of a total 70_000_000) >= 30_000_000 if it were
  # deleted.
  def self.part2(filename)
    tree = build_filetree(filename)
    space_needed = 30_000_000 - (70_000_000 - tree.size)
    tree.dirs.select { |dir| dir.size >= space_needed }.min_of(&.size)
  end

  def self.main(filename)
    puts "Day 7:"
    puts "Part 1: #{part1(filename)}"
    puts "Part 2: #{part2(filename)}"
    puts "=" * 40
  end
end