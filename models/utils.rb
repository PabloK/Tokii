module Utils
  include Math

  def rotate_point p, rot
    rot = to_rad(rot)
    return [p[0]*cos(rot) -p[1]*sin(rot) , p[0]*sin(rot) + p[1]*cos(rot)]
  end
  
  def to_rad degree
    return degree * Math::PI/180
  end

  def to_deg degree
    return degree * 180/Math::PI
  end

  def rotate_line line, rot
    return [rotate_point(line[0],rot),rotate_point(line[1],rot)]
  end

  def chunk_array(array, pieces=2)
    len = array.size
    mid =  len / pieces
    chunks = []
    start = 0
    1.upto(pieces) do |i|
      last = start+mid
      last = last-1 unless len%pieces >= i
      chunks << array[start..last] || []
      start = last+1
    end
    return chunks
  end
  
      #TODO This is a place holder
  def getpowercolor color
    powercolor =:none
    if color[0].to_i > 40 and color[1].to_i < 64 and color[2].to_i < 64
      powercolor = :red
    elsif color[0].to_i < 64 and color[1].to_i > 40 and color[2].to_i < 64
      powercolor = :green
    elsif color[0].to_i < 64 and color[1].to_i < 64 and color[2].to_i > 40
      powercolor = :blue
    end
    return powercolor
  end
end
