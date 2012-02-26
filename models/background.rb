class Background < GameObject

  attr_accessor :surface
  def initialize width, height, color=[20,10,15]
    @bg_color = color
    @surface = Rubygame::Surface.new [width, height]
    @surface.fill @bg_color
    super 0, 0, surface
  end

  def redraw
    @surface.fill @bg_color
  end

end
