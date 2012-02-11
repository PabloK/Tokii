class Bound < GameObject
  def initialize x, y, width, height
    @bg_color = [250,250,250]
    
    @height = height
    @width = width
    @surface = Rubygame::Surface.new [width, height]
    @surface.fill [255,255,255]
    @x = x
    @y = y
    super @x, @y, surface

  end
  
  def inbounds? in_xy
    in_x = in_xy[0]
    in_y = in_xy[1]
    return true
  end

end
