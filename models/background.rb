class Background < GameObject

  def initialize width, height, color=[20,10,15]
    @bg_color = color
    @surface = Rubygame::Surface.new [width, height]
    @surface.fill @bg_color
    super 0, 0, surface
  end

end
