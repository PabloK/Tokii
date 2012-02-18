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

    #Ball.toggle_show_box
    Block.toggle_show_box

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
      scenery = (Block.new (@screen.width/3)*sin(2*PI*n/6)+@screen.width/2,(@screen.width/3)*cos(2*PI*n/6)+@screen.width/2, @screen.width/2.525, 20, 60*(n-1) + 60)
      scenery.draw @background.surface
    end

    20.times { @balls << (Ball.new 500, 500, 4,rand(100)-50,rand(100)-50) }

    for row in 1..8 do
      for m in 1..8 do
        next if m == 1 and (row == 1 or row == 8)
        next if m == 8 and (row == 1 or row == 8)
        for n in 1..6 do
        @blocks << (Block.new (40/3)*sin(2*PI*n/6)+210 + 42 *m,(40/3)*cos(2*PI*n/6)+230+42*row, 40/2.525, 4, 60*(n-1) + 60,[rand(255),rand(255),rand(255)])
        end
      end
    end

    @collisiondetector = CollisionSupervisor.new @balls, @blocks
  end

  def run!
    loop do 
      update
      draw
      @clock.tick
      puts @clock.framerate
      exit if @clock.ticks > 100
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
