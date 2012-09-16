class PlayerData

  attr_reader :name, :color, :score, :color_points, :last_color, :color_multiplier

  def initialize name, color
    @name = name
    @color = color
    @score = 0
    @color_points = {}
    @color_multiplier = 1
    @last_color = :none
  end
  
  def collide block
    @score += block.scorepoints
    if @last_color == block.powercolor and block.powercolor != :none
      if @color_points.has_key?(block.powercolor)
        @color_points[block.powercolor] += @color_multiplier
      else
        @color_points[block.powercolor] = 1
      end
      @color_multiplier += 1
    else
      @color_multiplier = 1
    end
    @last_color = block.powercolor
    print "Score: ", @score, " color: ", @last_color, "    Power: "
    color_points.each_key { |key| print key, color_points[key], "  " }
    print "\n"
    
  end
  
end
