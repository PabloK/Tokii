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
    @speed = 2
    @surface = Rubygame::Surface.new [width, height]
    @surface.draw_circle_s @center,radii, @bg_color
    @boundbox = {:topleft  => [@x - @radii - 1, @y - @radii - 1],
            :topright => [@x + @radii + 1, @y - @radii - 1],
            :bottomleft  => [@x - @radii - 1, @y + @radii + 1],
            :bottomright => [@x + @radii + 1,@y + @radii + 1]}
  end

  def move!
    @x = @x + @xspeed * @speed 
    @y = @y + @yspeed * @speed 

    @boundbox = {:topleft  => [@x - @radii, @y - @radii],
            :topright => [@x + @radii, @y - @radii],
            :bottomleft  => [@x - @radii, @y + @radii ],
            :bottomright => [@x + @radii ,@y + @radii]}
  end
  
  def bounce! target
      @xspeed = -@xspeed
      @yspeed = -@yspeed
  end

  def draw screen
    @surface.blit screen, [@x-@radii, @y-@radii]

    if @@show_box 
      screen.draw_line boundbox[:topleft], boundbox[:topright], [255,0,0]
      screen.draw_line boundbox[:topleft], boundbox[:bottomleft], [255,0,0]
      screen.draw_line boundbox[:bottomleft], boundbox[:bottomright], [255,0,0]
      screen.draw_line boundbox[:bottomright], boundbox[:topright], [255,0,0]
      screen.draw_line [@x,@y], [@x + @xspeed * 10 * @speed,@y+ @yspeed * 10 * @speed],[255,255,0]
    end
  end

  def self.toggle_show_box
    @@show_box = !@@show_box
  end

end
