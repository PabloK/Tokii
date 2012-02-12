class Ball < GameObject
  
  attr_reader :radii
  def initialize x, y, radii
    @bg_color = [250,250,250]
    
    height = width = radii * 2 + 1
    @center = [radii, radii]

    @surface = Rubygame::Surface.new [width, height]
    @surface.draw_circle_s @center,radii, @bg_color

    @radii = radii
    @x = x - radii 
    @y = y - radii 
    @xspeed = 0
    @yspeed = 1
    @speed = 1

  end

  def move!
    @x = @x + @xspeed * @speed 
    @y = @y + @yspeed * @speed 
  end
  
  def bounce! target
    @yspeed = -@yspeed
  end

  def draw screen
    @surface.blit screen, [@x, @y]
  end

end
