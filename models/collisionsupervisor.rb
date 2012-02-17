class CollisionSupervisor
  
  def initialize balls, blocks
    @balls = balls
    @blocks = blocks 
  end
  
  def collide!
    for ball in @balls do
      # ball on pad
      
      # ball on block
      for block in @blocks do
        if in_block_bound
          ball.bounce_on block if ball_block_collison
        end
      end
    end
  end
  
end
