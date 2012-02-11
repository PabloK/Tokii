class Ball < GameObject

  def initialize x, y, radii
    @bg_color = [250,250,250]
    
    height = width = radii * 2 + 2
    @center = [radii, radii]

    @surface = Rubygame::Surface.new [width, height]
    @surface.draw_circle_s @center,radii, @bg_color

    @radii = radii
    @x = x - radii - 2
    @y = y - radii - 2
    @xspeed = 0.0
    @yspeed = 1.0
    @speed = 2

  end

  def move!
    @x = @x + @xspeed * @speed 
    @y = @y + @yspeed * @speed 
  end
  
  def move?
    [@x + @xspeed,
     @y + @yspeed]
  end

  def bounce!
    @x = -@x
  end

  def draw screen
    puts(@x)
    @surface.blit screen, [@x, @y]
  end

  def scollide? target
    if target.inbounds? move?
      bounce!
    end
  end

end
