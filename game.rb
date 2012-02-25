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
    @clock.target_framerate = 60
    @queue = Rubygame::EventQueue.new
    @screen = Rubygame::Screen.new [1000,1000], 0 ,[Rubygame::HWSURFACE,Rubygame::DOUBLEBUF]
    @background = Background.new @screen.width, @screen.height
    @balls = []
    @blocks = []
    create_court
    100.times {@balls << (Ball.new 250+rand(500), 250+rand(500), 3 + rand(7), rand(100)-100,rand(100)-100) }
    @collisiondetector = CollisionSupervisor.new @balls, @blocks, @background
  end

  def run!
    loop do 
      @clock.tick
      update
      draw
    end
  end

  def update
    @collisiondetector.collide!
    handle_events
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
  
  def handle_events
    @queue.each do |event|
      case event 
        when Rubygame::QuitEvent
          Rubygame.quit
          exit
      end
    end
  end
  
  def create_court
    for n in 1..6 do
      @blocks << (Block.new (@screen.width/2.5)*sin(2*PI*n/6)+@screen.width/2,(@screen.width/2.5)*cos(2*PI*n/6)+@screen.width/2, @screen.width/2.11, 20, 60*(n-1) + 60)
    end
  end

end
g = Game.new
g.run!
