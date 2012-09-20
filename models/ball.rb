class Ball < GameObject
  
  @@show_box ||= false 

  attr_reader :radii, :boundbox, :x, :y, :speed, :color, :oldx, :oldy, :xspeed, :yspeed, :player
  attr_accessor :color

  def initialize x, y, radii, xspeed=1.0, yspeed=1.0
    @color = [255,255,255]
    @radii = radii
    @center = [radii, radii]
    @x = x + radii 
    @y = y + radii 
    @xspeed = xspeed/[xspeed.abs+yspeed.abs.to_f, 1.0].max
    @yspeed = yspeed/[xspeed.abs+yspeed.abs.to_f, 1.0].max
    @speed = 3;
    @oldx = @x
    @oldy = @y
    height = width = radii*2 + 1
    @surface = Rubygame::Surface.new [width, height]
    @surface.draw_circle_s @center,radii, @color
    @boundbox = {:x => @x,:y => @y,:width => @radii+3}
    @motion = 1
    @blitpointx = @x -@radii 
    @blitpointy = @y -@radii 
    #TODO Add a motion variable to the ball each ball is moved if it collides
    # it is unmoved and then moved the motion left untill all balls have 0 motion
    #motion is then reset upon entering a new frame
  end

  def move! 
    @oldx = @x
    @oldy = @y
    @x += @xspeed * @motion * @speed
    @y += @yspeed * @motion * @speed
    @motion = 0;
    @boundbox[:x] = @x
    @boundbox[:y] = @y
    @blitpointx = @x-@radii 
    @blitpointy = @y-@radii 
  end

  def unmove! bounce_line, isSimple=false
    if isSimple
      @x = bounce_line[0][0]
      @y = bounce_line[0][1]
      @motion = Math.sqrt((@oldx-@x)**2 + (@oldy-@y)**2)/@speed;
    end
    return @motion
  end

  def resetmotion
    @motion = 1
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

  def player= player
    @player = player
    @color = player.color
    @surface.draw_circle_s @center,radii, @color
  end

  def color= color
    @color = color
    @surface.draw_circle_s @center,radii, @color
  end

  def draw screen
    @surface.blit screen, [@blitpointx, @blitpointy]
  end

end
