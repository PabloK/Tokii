class Paddle < Block

  attr_accessor :color
  def initialize *args
    super(*args)
    @cooldown = 0
  end

  def move_left
    @x = @x - 3
    @boundbox = {:x => @x,:y => @y, :width => sqrt(@width**2 + @height**2)/2+3}
    @x = 320 if @x < 320
  end
  
  def move_right
    @x = @x + 3
    @x = 680 if @x > 680
    @boundbox = {:x => @x,:y => @y, :width => sqrt(@width**2 + @height**2)/2+3}
  end

  def teleport_down
    if @cooldown <= 0
      @x = 500
      @boundbox = {:x => @x,:y => @y, :width => sqrt(@width**2 + @height**2)/2+3}
      @cooldown = 150
    end
  end

  def draw stage
    @color[1] = 174 -@cooldown
    @surface.fill @color 
    super(stage)
  end
  
  def cooldown
    if @cooldown > 0
      @cooldown -=1
      puts @cooldown
    end
  end

end