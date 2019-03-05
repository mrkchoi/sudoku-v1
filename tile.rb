require 'colorize'
require 'colorized_string'
require 'byebug'

class Tile
  attr_reader :playable
  attr_accessor :value

  def initialize(value, playable)
    @value = value
    @playable = playable
  end

  def colorize
    # debugger
    if @playable == true
      return " #{@value} ".colorize(:color => :black, :background => :light_cyan)
    else
      return " #{@value} ".colorize(:color => :black, :background => :white)
    end
  end
end

# t0 = Tile.new(0, true)
# t1 = Tile.new(1, false)
# t2 = Tile.new(2, false)
# t3 = Tile.new(3, false)
# t4 = Tile.new(4, false)
# t5 = Tile.new(5, false)
# t6 = Tile.new(6, false)
# t7 = Tile.new(7, false)
# t8 = Tile.new(8, false)
# t9 = Tile.new(9, false)

# puts t0.to_s
# puts t1.to_s
# puts t2.to_s
# puts t3.to_s
# puts t4.to_s
# puts t5.to_s
# puts t6.to_s
# puts t7.to_s
# puts t8.to_s
# puts t9.to_s

# String.color_samples