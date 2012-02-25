#encoding utf-8
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
    @clock.target_framerate = 50

    @queue = Rubygame::EventQueue.new
    @screen = Rubygame::Screen.new [800,800], 0,
                                   [Rubygame::HWSURFACE,Rubygame::DOUBLEBUF]
    @screen.title = "Tokii"
    @background = Background.new @screen.width, @screen.height

    @balls = []
    @blocks = []
    @scenery = []

    for n in 1..6 do
      @blocks << (Block.new (@screen.width/3)*sin(2*PI*n/6)+@screen.width/2,(@screen.width/3)*cos(2*PI*n/6)+@screen.width/2, @screen.width/2.525, 20, 60*(n-1) + 60)
    end
    
   50.times {@balls << (Ball.new 300+rand(230), 300+rand(220), 4, rand(50)-50,rand(50)-50) }
   @balls << (Ball.new 300, 300+rand(220), 4, 0,-50)
   @balls << (Ball.new 299, 300+rand(220), 4, 0,50)
    
    colors = [[170,150,30],[170,30,30],[170,30,150],[30,190,30],[30,150,170],[30,30,170]]

    @collisiondetector = CollisionSupervisor.new @balls, @blocks, @background
  end

  def run!
    loop do 
      update
      draw
      @clock.tick
    end
  end

  def update
    @collisiondetector.collide!
    @queue.each do |event|
      case event 
        when Rubygame::QuitEvent
          Rubygame.quit
          exit
      end
    end
  end
  
  def draw
    @background.draw @screen

    for block in @blocks do
      block.draw @screen
    end

    for ball in @balls do
      ball.draw @screen
    end

    @screen.flip
  end 

end
g = Game.new
g.run!
