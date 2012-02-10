require "rubygems"
require "matrix"

class Background < GameObject

  def initialize width, height
    @borderwidth = 10
    @border_color = [255,255,255]
    @surface = Rubygame::Surface.new [width, height]
    update 
    super 0,0,surface
  end
  
  def color_rotate!
    @border_color  = [rand(254)+1,150,rand(254)+1]
  end
  
  def update
    color_rotate!
    surface.draw_box_s [0, 0], [surface.width, @borderwidth], @border_color
    surface.draw_box_s [0, 0], [@borderwidth, surface.height], @border_color
    surface.draw_box_s [0, surface.height-@borderwidth], [surface.width, surface.height], @border_color
    surface.draw_box_s [surface.width-@borderwidth, 0], [surface.width,surface.height], @border_color
  end

end
