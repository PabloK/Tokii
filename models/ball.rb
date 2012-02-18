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
    @boundbox = {:tl => [@x - @radii - 1, @y - @radii - 1],
                 :tr => [@x + @radii + 1, @y - @radii - 1],
                 :bl => [@x - @radii - 1, @y + @radii + 1],
                 :br => [@x + @radii + 1, @y + @radii + 1]}
  end

  def move!
    movementx = @xspeed * @speed
    movementy = @yspeed * @speed

    @x += movementx 
    @y += movementy
    
    @boundbox[:tl][0] += movementx
    @boundbox[:tr][0] += movementx
    @boundbox[:bl][0] += movementx
    @boundbox[:br][0] += movementx
    @boundbox[:tl][1] += movementy
    @boundbox[:tr][1] += movementy
    @boundbox[:bl][1] += movementy
    @boundbox[:br][1] += movementy

  end
  
  def bounce! target
      @xspeed = -@xspeed
      @yspeed = -@yspeed
  end

  def draw screen
    @surface.blit screen, [@x-@radii, @y-@radii]

    if @@show_box 
      screen.draw_line boundbox[:tl], boundbox[:tr], [255,0,0]
      screen.draw_line boundbox[:tr], boundbox[:bl], [255,0,0]
      screen.draw_line boundbox[:bl], boundbox[:br], [255,0,0]
      screen.draw_line boundbox[:br], boundbox[:tr], [255,0,0]
      screen.draw_line [@x,@y], [@x + @xspeed * 10 * @speed,@y+ @yspeed * 10 * @speed],[255,255,0]
    end
  end

  def self.toggle_show_box
    @@show_box = !@@show_box
  end

end
