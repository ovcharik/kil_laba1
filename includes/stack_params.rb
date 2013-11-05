module StackParams
  
  def add_new_params(stack, x, y, only_cross = false)
    stack << [x - 0, y - 1]
    
    stack << [x - 1, y - 0]
    stack << [x + 1, y - 0]
    
    stack << [x - 0, y + 1]
    
    unless only_cross
      stack << [x - 1, y - 1]
      stack << [x + 1, y - 1]
      stack << [x - 1, y + 1]
      stack << [x + 1, y + 1]
    end
  end
  
end
