class CollisionSupervisor
  
  def initialize balls, blocks
    @balls = balls
    @blocks = blocks 
  end
  
  def ball_block_collision ball, block
    #find block sides equations
    #solve the equation
    #if the equation has solutions
      #calculate the side normal
      #calculate
  end
  
  def box_overlap box1, box2
    box2.each_value do |v|
      return true if v[0] < box1[:tr][0] and v[0] > box1[:tl][0] and (v[1] < box1[:bl][1] and v[1] > box1[:tl][1])
    end
    return false
  end
  
  def collide!
    for ball in @balls do
      bounced = false

      for block in @blocks do
        if box_overlap block.boundbox, ball.boundbox
          if ball_block_collision ball, block
            ball.bounce! block
            bounced = true
            exit
          end
        end
      end
      
      ball.move! unless bounced
      # ball on ball on ball
    end
  end
  
end
