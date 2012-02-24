require "rspec"
require "rubygame"
require "./models/gameobject"
require "./models/ball"

describe Ball do

  it "moves around" do
    ball = Ball.new 400, 400, 10,1,1
    ball.move!
    ball.x.should_not eq(400)
    ball.y.should_not eq(400)
  end

end
