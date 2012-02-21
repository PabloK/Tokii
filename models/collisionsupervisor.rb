class CollisionSupervisor
  
  def initialize balls, blocks, screen
    @balls = balls
    @blocks = blocks 
    @screen = screen
  end
  
  def ball_block_collision ball, block
    block_lines = []
    block_lines << [:tr,:tl]
    block_lines << [:br,:bl]
    block_lines << [:tr,:br]
    block_lines << [:tl,:bl]

    for line in block_lines do

      p1 = block.cord line[0]
      p2 = block.cord line[1]
      
      p1[0] -= ball.x
      p1[1] -= ball.y
      p2[0] -= ball.x
      p2[1] -= ball.y
   
      dx  = p1[0] - p2[0]
      dy  = p1[1] - p2[1]
      dr = dy**2 + dx**2
      d   = p1[0]*p2[1]-p2[0]*p1[1]
      disc = ball.radii**2 * dr - d**2

      if disc >= 0 
        return false if  0 > p1[0] and ball.radii > p2[0] 
        return false if  0 < p1[0] and ball.radii < p2[0] 
        return false if  0 < p1[1] and ball.radii < p2[1] 
        return false if  0 > p1[1] and ball.radii > p2[1] 
        return true
      end
       
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
            block.color = [rand(255),rand(255),rand(255)]
            next
          end
        end
      end
      ball.move! unless bounced
    end
  end
  
end
