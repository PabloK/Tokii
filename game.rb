require "rubygems"
require "rubygame"

#
# Class that handels a Tokii game
#
class Game
  def initialize
    @screen = Rubygame::Screen.new [800,600], 0,
                                   [Rubygame::HWSURFACE,Rubygame::DOUBLEBUF]
    @screen.title = "Tokii"
    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 60

  end
 
  #
  # The game loop
  # 
  def run!
    loop do 
      update
      draw
      @clock.tick
    end
  end

  #
  # Updates game logic depending input
  #
  def update
    @queue.each do |event|
      case event 
        when Rubygame::QuitEvent
          Rubygame.quit
          exit
      end
    end
  end
  
  #
  # Draws game board
  #
  def draw
    nil    
  end 

end

g = Game.new
g.run!
