class Block < GameObject
  include Utils
  include Math
  
  @@show_box ||= false 

  attr_reader :x,:y,:width,:height,:boundbox, :rotation,:color
  
  def initialize x, y, width, height, rotation=0, color=[30,35,50]
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
    @minbox = sqrt(@halfw**2 + @halfh**2)+0.1
    @boundbox = {:x => @x,:y => @y, :width => sqrt(@width**2 + @height**2)/2+1}
  end
  
  def color= color
    @color = color
    @surface.fill @color
  end
  
  def draw screen
    temp = @surface.rotozoom(@rotation,1,false)
    temp.blit screen, [@x-temp.width/2, @y-temp.height/2]
  end
  
  def cord pos 
    cosr = cos(@rotation*PI/180)
    sinr = sin(@rotation*PI/180)
    cwidth = @halfw * cosr
    cheight = @halfh * cosr 
    sheight = @halfh * sinr
    swidth = @halfw * sinr
    return [@x-cwidth, @y+swidth] if pos == :midw
    return [@x-sheight, @y-cheight] if pos == :midh
    return [@x-cwidth-sheight, @y+swidth-cheight] if pos == :tl
    return [@x+cwidth-sheight, @y-swidth-cheight] if pos == :tr
    return [@x-cwidth+sheight, @y+swidth+cheight] if pos == :bl
    return [@x+cwidth+sheight, @y-swidth+cheight] if pos == :br
  end
end
