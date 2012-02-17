class Block < GameObject
  include Utils
  include Math
  
  attr_reader :x,:y,:width,:height
  
  def initialize x, y, width, height, rotation=0
    @height = height
    @width = width
    @surface = Rubygame::Surface.new [width, height]
    @surface.fill [255,255,255]
    @x = x
    @y = y
    @rotation = rotation
  end
  
  def draw screen
    temp = @surface.rotozoom(@rotation,1,false)
    temp.blit screen, [@x-temp.width/2, @y-temp.height/2]
  end

  def line pos
    cwidth = @width/2 * cos(@rotation*Math::PI/180) 
    cheight = @height/2 * cos(@rotation*Math::PI/180) 
    sheight = @height/2 * sin(@rotation*Math::PI/180) 
    swidth = @width/2 * sin(@rotation*Math::PI/180) 

    midw = [@x + swidth, @y - cwidth]
    midh = [@x + cheight, @y - sheight]
    
    return midw + midh if pos == :top 
      
  end
  
end
