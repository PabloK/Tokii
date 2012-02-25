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
    @blocks += create_breakables [@screen.width/2,@screen.width/2]
    
    50.times {@balls << (Ball.new 250+rand(500), 250+rand(500), 3 + rand(7), rand(100)-100,rand(100)-100) }
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
    @blocks += hexagon_factory([@screen.width/2,@screen.width/2],Block,@screen.width,20)
  end
  #move this? this is only a demo.version.
  def create_breakables centre
    blocks=[]
    for n in 1..5 do
      blocks += hexsymetric_factoy([0,45*n],centre,Block,50,5)
      blocks += hexsymetric_factoy([39,22.5+45*n],centre,Block,50,5)
    end
    for n in 2..5 do
      blocks += hexsymetric_factoy([-39,22.5+45*n],centre,Block,50,5)
    end
    for n in 3..5 do
      blocks += hexsymetric_factoy([78,45*n],centre,Block,50,5)
    end
    for n in 4..5 do
      blocks += hexsymetric_factoy([-78,45*n],centre,Block,50,5)
    end
    return blocks
  end
  #move this some where else?
  def hexagon_factory position, blocktype, width, thickness
    blocks=[]
    for n in 1..6 do
      blocks << blocktype.new((width/2.5)*sin(2*PI*n/6)+position[0],(width/2.5)*cos(2*PI*n/6)+position[1], width/2.11, thickness, 60*(n-1) + 60)
    end
    return blocks
  end
  #move this somwhere else?
  def hexsymetric_factoy position, centre, blocktype, width, thickness
    blocks=[]
    for n in 1..6 do 
      xpos=position[0]*cos(2*PI*n/6) - position[1]*sin(2*PI*n/6)+centre[0]
      ypos=position[0]*sin(2*PI*n/6) + position[1]*cos(2*PI*n/6)+centre[1]
      blocks += hexagon_factory([xpos,ypos],blocktype,width,thickness)
      for i in 0..5 do #TODO remove only to make better visuals for now
        blocks[(n-1)*6+i].color=[rand(255),rand(255),rand(255)]
        puts blocks[(n-1)*6+i].color
      end
    end
    return blocks
  end
end
g = Game.new
g.run!
