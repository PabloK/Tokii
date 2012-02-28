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
    @blockground = Background.new @screen.width, @screen.height
    @balls = []
    @blocks = []
    @colors = [[00,255,56],[00,40,255],[255,174,0],[255,28,00],[224,00,255]]
    create_court
    @blocks += create_breakables [@screen.width/2,@screen.width/2]
    6.times {@balls << (Ball.new 240 + rand(80), 240+rand(80), 4, rand(100)-100,rand(100)-100) }
    @collisiondetector = CollisionSupervisor.new @balls, @blocks, @background
    @first_frame = true
  end

  def run!
    min = 50
    loop do 
      update
      draw
      @clock.tick
    end
  end

  def update
    @collisiondetector.collide!
    handle_events
  end

  def draw
    @background.draw @screen
    if @collisiondetector.renew or @first_frame 
      draw_blocks
    end
    draw_balls
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
  
  def draw_blocks 
    @background.redraw
    for block in @blocks do
        block.draw @background.surface
    end
    @first_frame = false
  end
  
  def draw_balls
    for ball in @balls do
      ball.draw @screen
    end
  end
  
  def create_court
    @blocks += hexagon_factory([@screen.width/2,@screen.width/2],Block,@screen.width,20,[[40,40,40]])
  end

  def create_breakables centre, sym=[6,2,3,1,3]
    blocks=[]
    for n in 1..sym[0] do
      blocks += hexsymetric_factoy([0,45*n],centre,Block,45,4)
    end
    for n in 1..sym[1]
      blocks += hexsymetric_factoy([39,22.5+45*n],centre,Block,45,4)
    end
    for n in 2..sym[2] do
      blocks += hexsymetric_factoy([-39,22.5+45*n],centre,Block,45,4)
    end
    for n in 3..sym[3] do
      blocks += hexsymetric_factoy([78,45*n],centre,Block,45,4)
    end
    for n in 4..sym[4] do
      blocks += hexsymetric_factoy([-78,45*n],centre,Block,45,4)
    end
      blocks += hexsymetric_factoy([0,0],centre,Block,45,4)
    return blocks
  end

  def hexagon_factory position, blocktype, width, thickness,colors,breakable=false
    blocks=[]
    for n in 1..6 do
      color =  colors[rand(colors.length)]
      blocks << blocktype.new((width/2.5)*sin(2*PI*n/6)+position[0],(width/2.5)*cos(2*PI*n/6)+position[1], width/2.11, thickness, 60*(n-1) + 60,color ,breakable)
    end
    return blocks
  end

  def hexsymetric_factoy position, centre, blocktype, width, thickness
    blocks=[]
    for n in 1..6 do 
      xpos=position[0]*cos(2*PI*n/6) - position[1]*sin(2*PI*n/6)+centre[0]
      ypos=position[0]*sin(2*PI*n/6) + position[1]*cos(2*PI*n/6)+centre[1]
      blocks += hexagon_factory([xpos,ypos],blocktype,width,thickness,@colors,true)
    end
    return blocks
  end
end
g = Game.new
g.run!
