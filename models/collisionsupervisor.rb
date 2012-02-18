class CollisionSupervisor
  
  def initialize balls, blocks
    @balls = balls
    @blocks = blocks 
  end
  
  def ball_block_collision ball, block
    return false
  end
  
  def box_overlap box1, box2
    box2.each_value do |v|
      if v[0] < box1[:topright][0] and v[0] > box1[:topleft][0] and (v[1] < box1[:bottomleft][1] and v[1] > box1[:topleft][1])
          return true
        end
    end
    return false
  end
  
  def collide!
    for ball in @balls do
      # ball on pad
      
      # ball on block
      for block in @blocks do
        if box_overlap block.boundbox, ball.boundbox
          ball.bounce! block if ball_block_collision ball, block
        end
      end
      # ball on ball on ball
    end
  end
  
end
