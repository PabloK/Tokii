class Ball < GameObject
  
  @@show_box ||= false 

  attr_reader :radii, :boundbox, :x, :y
  def initialize x, y, radii, xspeed=1.0, yspeed=1.0

    height = width = radii * 2 + 1
    @bg_color = [250,250,250]
    @center = [radii, radii]
    @radii = radii
    @x = x + radii 
    @y = y + radii 
    @xspeed = xspeed/[xspeed.abs+yspeed.abs.to_f, 1.0].max
    @yspeed = yspeed/[xspeed.abs+yspeed.abs.to_f, 1.0].max
    @speed = 1

    @surface = Rubygame::Surface.new [width, height]
    @surface.draw_circle_s @center,radii, @bg_color
    @boundbox = {:x => @x,:y => @y,:width => @radii+1}

  end

  def move!
    movementx = @xspeed * @speed
    movementy = @yspeed * @speed

    @x += movementx 
    @y += movementy
    
    @boundbox[:x] = @x
    @boundbox[:y] = @y

  end
  
  def bounce! target
      @xspeed = -@xspeed
      @yspeed = -@yspeed
  end

  def draw screen
    @surface.blit screen, [@x-@radii, @y-@radii]
  end

  def self.toggle_show_box
    @@show_box = !@@show_box
  end

end
