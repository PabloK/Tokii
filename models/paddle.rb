class Paddle < Block

  def move_left
    @x = @x - 10
  end
  
  def move_right
    @x = @x + 10
  end

end
