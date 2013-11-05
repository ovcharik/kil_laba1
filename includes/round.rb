module Round
  
  def round_dotes(x0, y0, r)
    result = []
    (0..360).step(1) do |f|
      a = f * Math::PI / 180
      x = x0 + r * Math.cos(a)
      y = y0 + r * Math.sin(a)
      result << [x.round, y.round]
      x = x0 + (r + 1) * Math.cos(a)
      y = y0 + (r + 1) * Math.sin(a)
      result << [x.round, y.round]
    end
    result.uniq
  end
  
  def round_include?(x, y, x0, y0, r)
    ((x0 - x)**2 + (y0 - y)**2) < (r**2)
  end
  
end
