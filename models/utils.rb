module Utils

  def left_of_line? x, y, p1, p2
   return  (p2[0]-p1[0])*(y-p1[1]) - (p2[1] - p1[1])*(x - p1[0]) > 0 
  end
  
end
