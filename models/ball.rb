class Ball < GameObject
  
  attr_reader :radii
  def initialize x, y, radii, xspeed=1, yspeed=1
    @bg_color = [250,250,250]
    
    height = width = radii * 2 + 1
    @center = [radii, radii]

    @surface = Rubygame::Surface.new [width, height]
    @surface.draw_circle_s @center,radii, @bg_color

    @radii = radii
    @x = x - radii 
    @y = y - radii 
    @xspeed = xspeed
    @yspeed = yspeed
    @speed = 2
    @bounce_timer = 0

  end

  def move!
    @x = @x + @xspeed * @speed 
    @y = @y + @yspeed * @speed 
  end
  
  def bounce! target
    if @bounce_timer == 0
      puts "bounce"
      @bounce_timer = @speed*2
    end
    @bounce_timer -= 1 if @bounce_timer >= 1
  end

  def draw screen
    @surface.blit screen, [@x, @y]
  end

end
