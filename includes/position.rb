module Position
  
  def position(c, r, columns, rows)
    if r >= 0 and r < rows and c >= 0 and c < columns
      c + r * columns
    end
  end
  
  def from_position(p, columns, rows)
    if p < columns * rows
      y = (p / columns).to_i
      x = p - y * columns
      [x, y]
    end
  end
  
end
