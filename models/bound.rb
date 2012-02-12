class Bound < GameObject
  
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
    temp = @surface.rotozoom(@rotation,1,true)
    temp.blit screen, [@x-temp.width/2, @y-temp.height/2]
  end
end
