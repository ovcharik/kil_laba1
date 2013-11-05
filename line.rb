class Line
  
  attr_reader :k, :b, :x, :y, :length
  
  def initialize(point1, point2)
    x1, y1 = point1[0], point1[1]
    x2, y2 = point2[0], point2[1]
    @k = (y1 - y2).to_f / (x1 - x2).to_f
    @b = (x1 * y2 - x2 * y1).to_f / (x1 - x2).to_f
    @x = x1 < x2 ? (x1..x2) : (x2..x1)
    @y = y1 < y2 ? (y1..y2) : (y2..y1)
    @length = Math.sqrt((y1 - y2)**2 + (x1 - x2)**2)
  end
  
  def distance_to_point(x, y)
    a = - @k
    c = - @b
    (a * x + y + c).abs / Math.sqrt(a**2 + 1)
  end
  
  def self.angle(line1, line2, deg = false)
    k1, k2 = line1.k, line2.k
    rad = Math.atan((k2 - k1) / (1 + k2 * k1)).abs
    if deg
      rad / Math::PI * 180
    else
      rad
    end
  end
  
end
