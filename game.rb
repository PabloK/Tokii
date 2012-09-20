#encoding utf-8
require "rubygems"
require './models/utils'
require "rubygame"
require "./models/gameobject"
require "./models/background"
require "./models/block"
require "./models/paddle"
require "./models/collisionsupervisor"
require "./models/ball"
require "./models/playerdata"

class Game
  include Math
  def initialize
    #TODO start threads that run thecollsion detection
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 75
    @screen = Rubygame::Screen.new [1000,1000], 0 ,[Rubygame::HWSURFACE,Rubygame::DOUBLEBUF]
    @background = Background.new @screen.width, @screen.height
    @blockground = Background.new @screen.width, @screen.height
    @balls = []
    @queue = Rubygame::EventQueue.new
    @pressed_keys = []
    @blocks = []
    @colors = [[00,255,56],[00,40,255],[255,174,0],[255,28,00],[224,00,255]]
    @players = []
    @players[0] = PlayerData.new('pl1', @colors[2])
    @players[1] = PlayerData.new('pl2', @colors[3])
    create_court
    @blocks += create_breakables [@screen.width/2,@screen.width/2]
    @paddles = [Paddle.new(@players[0],500, 110, 120, 15, 0,false)]
    @paddles << Paddle.new(@players[1],500, 890, 120, 15, 0,false)
    40.times {@balls << (Ball.new 750-rand(500),750-rand(500) , 3, 0,-1) }
    @collisiondetector = CollisionSupervisor.new @balls, @blocks, @background, @paddles
    @first_frame = true
    @start = 0
  end

  def run!
    loop do 
      update
      handle_events
      draw
      resetmotion
      @paddles.each do |paddle|
        paddle.cooldown
      end
      @clock.tick
      puts @clock.framerate
    end
  end

  def update
    @collisiondetector.collide!
  end

  def draw
    @background.draw @screen
    draw_paddles
    if @collisiondetector.renew or @first_frame
      draw_blocks
    end
    draw_balls
    @screen.flip
  end 
  
  def resetmotion
    @balls.each do |ball|
      ball.resetmotion
    end
  end

  def draw_paddles
    @paddles.each do |paddle|
      paddle.draw @screen
    end
  end
  
  def handle_events
    @queue.each do |event|
      case event 
        when Rubygame::QuitEvent
          Rubygame.quit
          exit
        when Rubygame::KeyDownEvent
          @pressed_keys << event.key
        when Rubygame::KeyUpEvent
          @pressed_keys.delete_if {|key| key == event.key}
      end
    end    
    # TODO loop trough array and execute actions
    @pressed_keys.each do |key|
      if key == Rubygame::K_LEFT
        @paddles[0].move_left 
      elsif key == Rubygame::K_RIGHT
        @paddles[0].move_right
      elsif key == Rubygame::K_DOWN
        @paddles[0].teleport_down
      end
      if key == Rubygame::K_A
        @paddles[1].move_left 
      elsif key == Rubygame::K_D
        @paddles[1].move_right
      elsif key == Rubygame::K_S
        @paddles[1].teleport_down
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

  def create_breakables centre, sym=[rand(4),rand(4),rand(3),rand(4),rand(4)]
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
