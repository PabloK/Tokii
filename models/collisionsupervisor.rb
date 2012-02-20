class CollisionSupervisor
  
  def initialize balls, blocks
    @balls = balls
    @blocks = blocks 
  end
  
  def ball_block_collision ball, block
    block_lines = [[:tr,:br],[:br,:bl],[:bl,:tl],[:tl,:tr]]  
    for line in block_lines do
      p1 = block.cord line[0]
      p2 = block.cord line[1]
      p1[0] -= ball.x     
      p1[1] -= ball.y
      p2[0] -= ball.x     
      p2[1] -= ball.y     
   
      dx  = p2[0] - p1[0]
      dy  = p2[0] - p1[0]
      dr = dy**2 + dx**2
      d   = p1[0]*p2[1]-p2[0]*p1[1]
      disc = ball.radii**2 * dr - d**2
      return disc >= 0
       
    end
    return false
  end
  
  def box_overlap box1, box2
    return box1[:width] + box2[:width] >= (box1[:x] - box2[:x]).abs if box1[:width] + box2[:width] >= (box1[:y] - box2[:y]).abs
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
            ball.move!
            block.color = [255,0,0]
            next
          end
        end
      end
      ball.move! unless bounced
    end
  end
  
end
