class Ball < GameObject
  
  @@show_box ||= false 

  attr_reader :radii, :boundbox, :x, :y, :speed, :color, :oldx, :oldy, :xspeed, :yspeed

  def initialize x, y, radii, xspeed=1.0, yspeed=1.0
    @color = [255,255,255]
    @radii = radii
    @center = [radii, radii]
    @x = x + radii 
    @y = y + radii 
    @xspeed = xspeed/[xspeed.abs+yspeed.abs.to_f, 1.0].max
    @yspeed = yspeed/[xspeed.abs+yspeed.abs.to_f, 1.0].max
    @oldx = @x
    @oldy = @y
    @speed = 5
    height = width = radii*2 + 1
    @surface = Rubygame::Surface.new [width, height]
    @surface.draw_circle_s @center,radii, @color
    @boundbox = {:x => @x,:y => @y,:width => @radii+3}
  end

  def move! motion_left
    motion_left = @speed unless motion_left
    @oldx = @x
    @oldy = @y
    @x += @xspeed * motion_left
    @y += @yspeed * motion_left
    @boundbox[:x] = @x
    @boundbox[:y] = @y
  end

  def unmove! collision_line
    @x -= @speed*@xspeed
    @y -= @speed*@yspeed
    @boundbox[:x] = @x
    @boundbox[:y] = @y
    return 0
  end
  
  def bounce! collision_line
      dx = collision_line[0][0]-collision_line[1][0] 
      dy = collision_line[0][1]-collision_line[1][1]
      reflex_matrix=[[dx**2-dy**2,2*dx*dy],[2*dx*dy,dy**2-dx**2]]
      xv = reflex_matrix[0][0]*@xspeed + reflex_matrix[0][1]*@yspeed
      yv = reflex_matrix[1][0]*@xspeed + reflex_matrix[1][1]*@yspeed
      @xspeed = xv/[xv.abs+yv.abs.to_f, 1.0].max
      @yspeed = yv/[xv.abs+yv.abs.to_f, 1.0].max
  end

  def color= color
    @color = color
    @surface.draw_circle_s @center,radii, @color
  end

  def draw screen
    @surface.blit screen, [@x-@radii, @y-@radii]
  end

end
