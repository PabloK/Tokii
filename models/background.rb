class Background < GameObject

  def initialize width, height
    @bg_color = [5,5,5]
    @surface = Rubygame::Surface.new [width, height]
    @surface.fill @bg_color
    super 0, 0, surface
  end

end
