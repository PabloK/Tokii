class Block < GameObject
  include Utils
  include Math
  
  @@show_box ||= false 

  attr_reader :x,:y,:width,:height, :boundbox
  
  def initialize x, y, width, height, rotation=0, color=[255,255,255]
    @height = height
    @width = width
    @x = x
    @y = y
    @rotation = rotation
    @halfh = @height / 2
    @halfw = @width / 2
    @color = color
    @surface = Rubygame::Surface.new [width, height]
    @surface.fill @color
    @boundbox = {:topleft  => [@x -@halfw -@halfh, @y -@halfw -@halfh],
            :topright => [@x +@halfw+@halfh,@y -@halfw -@halfh],
            :bottomleft  => [@x -@halfw -@halfh, @y +@halfw +@halfh],
            :bottomright => [@x +@halfw+@halfh,@y +@halfw +@halfh]}
  end
  
  def draw screen
    
    temp = @surface.rotozoom(@rotation,1,false)
    temp.blit screen, [@x-temp.width/2, @y-temp.height/2]

    if @@show_box 
      screen.draw_line boundbox[:topleft], boundbox[:topright], [255,0,0]
      screen.draw_line boundbox[:topleft], boundbox[:bottomleft], [255,0,0]
      screen.draw_line boundbox[:bottomleft], boundbox[:bottomright], [255,0,0]
      screen.draw_line boundbox[:bottomright], boundbox[:topright], [255,0,0]
      screen.draw_line line(:midw), [@x,@y], [255,0,0]
      screen.draw_line line(:midh), [@x,@y], [255,0,0]
    end
  end


  def line pos 
    cosr = cos(@rotation*0.0174532925)
    sinr = sin(@rotation*0.0174532925)
    cwidth = @halfw * cosr
    cheight = @halfh * cosr 
    sheight = @halfh * sinr
    swidth = @halfw * sinr

    midw = [@x-cwidth, @y+swidth]
    midh = [@x-sheight, @y-cheight]
    
    return midw if pos == :midw
    return midh if pos == :midh
  end

  def self.toggle_show_box
    @@show_box = !@@show_box or True
  end
  
end
