require './models/utils'
class CollisionSupervisor
  include Utils 
  def initialize balls, blocks, screen
    @balls = balls
    @blocks = blocks 
    @screen = screen
  end
  
  def find_zone point, corners
    if point[1] > corners[:br][1] 
      return :bl if point[0] <= corners[:bl][0]
      return :br if point[0] >= corners[:br][0]
      return :b  
        
    elsif point[1] < corners[:tr][1]
      return :tl if point[0] <= corners[:tl][0]
      return :tr if point[0] >= corners[:tr][0]
      return :t 
    
    else 
      return :ml if point[0] <= corners[:bl][0]
      return :mr if point[0] >= corners[:br][0]
      return :in
    end
  end
  
  def select_line zone
    return [:tr,:tl] if zone == :t
    return [:br,:bl] if zone == :b
    return [:bl,:tl] if zone == :ml
    return [:br,:tr] if zone == :mr
    return [:tl,:tr] if zone == :tr
    return [:tl,:tr] if zone == :tl
    return [:br,:bl] if zone == :bl
    return [:br,:bl] if zone == :br
    return nil

  end

  def ball_block_collision ball, block
    block_corners = [:tr,:br,:bl,:tl]
    corners = {}
    for point in block_corners do
      corners[point] = rotate_point block.cord(point), block.rotation
    end 

    ball_point = rotate_point [ball.oldx, ball.oldy], block.rotation
    line = select_line(find_zone(ball_point, corners))
    ball_point = rotate_point [ball.x, ball.y], block.rotation if line

    if find_zone(ball_point, corners) == :in and line
      corner1 = corners[line[0]]
      corner2 = corners[line[1]]
      line = [corner1, corner2 ]
      real_line = rotate_line line, -block.rotation
      return real_line 
    end

    #TODO if the discriminant is larger or equal to zero we return the line

    return false
  end
  
  def box_overlap box1, box2
    if box1[:width] + box2[:width] >= (box1[:y] - box2[:y]).abs
      return box1[:width] + box2[:width] >= (box1[:x] - box2[:x]).abs 
    end
    return false
  end
 
  def ball_overlap ball1, ball2
    dx = ball2.x - ball1.x 
    dy = ball2.y - ball1.y
    return Math.sqrt(dx**2 + dy**2) < ball1.radii+ball2.radii
  end 
  
  def ball_blocks_collider! ball
    for block in @blocks do
      next unless box_overlap block.boundbox, ball.boundbox
      bounce_line = ball_block_collision ball, block
      next unless bounce_line
      motion_left = ball.unmove! bounce_line
      ball.bounce! bounce_line
      ball_controller! ball, motion_left if motion_left > 0.1
      @blocks.delete(block) if block.breakable
    end
  end

  def ball_collider! ball
    for ball2 in @balls do
      next if ball.object_id == ball2.object_id
      next unless box_overlap ball2.boundbox, ball.boundbox
      next unless ball_overlap ball, ball2

      dx = ball2.x - ball.x 
      dy = ball2.y - ball.y
      bounce_line =  [[0,0],[-dy,dx]]

      #TODO here we should realy calculate how much to move the ball backwards
      #Then we should move each half of the way and remove it
      ball.unmove! bounce_line
      ball2.unmove! bounce_line
      ball2.bounce! bounce_line
      ball.bounce! bounce_line
    end
  end

  def ball_controller! ball
    ball.move! 
    ball_blocks_collider! ball 
    ball_collider! ball
  end

  def collide! 
    for ball in @balls do
      ball_controller! ball
    end
  end
end
