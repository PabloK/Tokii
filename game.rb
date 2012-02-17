require "rubygems"
require './models/utils'
require "rubygame"
require "./models/gameobject"
require "./models/background"
require "./models/block"
require "./models/collisionsupervisor"
require "./models/ball"

class Game
  include Math
  def initialize
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 70
    @queue = Rubygame::EventQueue.new
    @screen = Rubygame::Screen.new [1000,1000], 0,
                                   [Rubygame::HWSURFACE,Rubygame::DOUBLEBUF]
    @screen.title = "Tokii"
    @background = Background.new @screen.width, @screen.height

    @balls = []
    @blocks = []

    @balls << (Ball.new 500, 500, 4,0)
    @balls << (Ball.new 500, 500, 4,0,1)
    @balls << (Ball.new 500, 500, 4,-1)

    for n in 1..6 do
      @blocks << (Block.new (@screen.width/3)*sin(2*PI*n/6)+@screen.width/2,(@screen.width/3)*cos(2*PI*n/6)+@screen.width/2, @screen.width/2.525, 20, 60*(n-1) + 60)
    end

    @collisiondetector = CollisionSupervisor.new @balls, @blocks
  end

  # 
  #
  def run!
    loop do 
      update
      draw
      @clock.tick
      exit if @clock.ticks > 200
    end
  end

  # Update game court
  #
  def update
    
    @collisiondetector.collide!
    for object in @balls do
      object.move!
    end

    @queue.each do |event|
      case event 
        when Rubygame::QuitEvent
          Rubygame.quit
          exit
      end
    end
  end
  
  # Draw objects
  # 
  def draw
    @background.draw @screen
    for object in @balls + @blocks do
      object.draw @screen
    end
    @screen.flip
  end 

end
g = Game.new
g.run!
