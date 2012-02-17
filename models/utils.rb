module Utils

  def left_of_line? x, y, x1, y1, x2, y2
   return  (x2-x1)*(y-y1) - (y2 - y1)*(x - x1) > 0 
  end
  
end
