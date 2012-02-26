class CollisionSupervisor
  
  attr_accessor :renew
  def initialize balls, blocks, screen
    @balls = balls
    @blocks = blocks 
    @screen = screen
    @renew = false
  end
  
  def ball_block_collision ball, block
    block_side = [[:tr,:tl],[:br,:bl],[:tr,:br],[:tl,:bl]]

    #TODO improve collision detection with tail
    for line in block_side do

      p1 = block.cord line[0]
      p2 = block.cord line[1]
      
      # Corner bounce
      # TODO return correct line on corner bounce
      return [p1,p2] if (ball.x - p1[0]).abs < ball.radii and (ball.y - p1[1]).abs < ball.radii 
      return [p1,p2] if (ball.x - p2[0]).abs < ball.radii and (ball.y - p2[1]).abs < ball.radii


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
        pmax = [[p1[0],p2[0]].max,[p1[1],p2[1]].max]
        pmin = [[p1[0],p2[0]].min,[p1[1],p2[1]].min]
        return false if -ball.radii > pmin[0] and ball.radii > pmax[0]
        return false if -ball.radii < pmin[0] and ball.radii < pmax[0]
        return false if -ball.radii > pmin[1] and ball.radii > pmax[1]
        return false if -ball.radii < pmin[1] and ball.radii < pmax[1]
        return [p1, p2]
      end
       
    end

    return false
  end
  
  def box_overlap box1, box2
    if box1[:width] + box2[:width] >= (box1[:y] - box2[:y]).abs
      return box1[:width] + box2[:width] >= (box1[:x] - box2[:x]).abs 
    end
    return false
  end
 
  def ball_overlap ball1, ball2
    dx = ball1.x-ball2.x 
    dy = ball1.y-ball2.y
    return [[0,0],[-dy,dx]] if Math.sqrt(dx**2+dy**2) < ball1.radii+ball2.radii
    return false
  end 
  
  def ball_blocks_collider! ball
    for block in @blocks do
      next unless box_overlap block.boundbox, ball.boundbox
      bounce_line = ball_block_collision ball, block
      next unless bounce_line
      motion_left = ball.unmove! bounce_line
      ball.bounce! bounce_line
      ball_controller! ball, motion_left if motion_left > 0.1
      @renew = true if block.breakable
      @blocks.delete(block) if block.breakable
    end
  end

  def ball_collider! ball
    for ball2 in @balls do
      next if ball.object_id == ball2.object_id
      next unless box_overlap ball2.boundbox, ball.boundbox
      bounce_line = ball_overlap ball, ball2
      next unless bounce_line
      motion_left = ball.unmove! bounce_line
      ball.bounce! bounce_line
      ball2.bounce! bounce_line
      ball_controller! ball, motion_left if motion_left > 0.1
    end
  end

  def ball_controller! ball, motion_left=ball.speed
    ball.move! motion_left
    ball_blocks_collider! ball 
    ball_collider! ball
  end

  def collide!
    @renew = false
    for ball in @balls do
      ball_controller! ball
    end
  end
end
