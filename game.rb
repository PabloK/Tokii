require "rubygems"
require "rubygame"
require "./models/gameobject"
require "./models/background"

#
# Class that handels a Tokii game
#
class Game
  def initialize
    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 40

    @screen = Rubygame::Screen.new [800,600], 0,
                                   [Rubygame::HWSURFACE,Rubygame::DOUBLEBUF]
    @screen.title = "Tokii"
    @background = Background.new @screen.width, @screen.height

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
    @background.update if @clock.lifetime.even?
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
    @screen.fill [0,0,0]
    @background.draw @screen
    @screen.flip
  end 

end

g = Game.new
g.run!
