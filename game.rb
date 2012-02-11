require "rubygems"
require "rubygame"
require "./models/gameobject"
require "./models/background"
require "./models/bound"
require "./models/collisionsupervisor"
require "./models/ball"

class Game
  def initialize
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 60
    @queue = Rubygame::EventQueue.new
    @screen = Rubygame::Screen.new [800,600], 0,
                                   [Rubygame::HWSURFACE,Rubygame::DOUBLEBUF]
    @screen.title = "Tokii"
    @background = Background.new @screen.width, @screen.height

    @moving = []
    @moving << (Ball.new 400, 300, 5)
    @stale = []
    @stale << (Bound.new 0, 0,@screen.width,5)
    @stale << (Bound.new 0, 595,@screen.width,5)
    @collisiondetector = CollisionSupervisor.new @moving, @stale

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
    for object in @moving do
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
  
  def draw
    @background.draw @screen
    for object in @stale + @moving do
      object.draw @screen
    end
    @screen.flip
  end 

end
g = Game.new
g.run!
