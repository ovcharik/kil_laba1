require './image'
require './figure'

require './includes/position'
require './includes/stack_params'

class FigureFinder
  include Position
  include StackParams
  
  attr_reader :figures
  
  def initialize(image)
    
    @figures = []
    
    pixels = image.pixels.dup
    rows = image.rows
    columns = image.columns
    
    for r in (0...rows)
      for c in (0...columns)
        p = position(c, r, columns, rows)
        if p and pixels[p]
          @figures << Figure.new(*find(c, r, pixels, columns, rows))
        end
      end
    end
    
  end
  
  private
  
  def find(c, r, pixels, columns, rows)
    coords = find_coords(c, r, pixels.dup, columns, rows)
    
    width  = coords[:right]  - coords[:left] + 3
    height = coords[:bottom] - coords[:top]  + 3
    
    left = coords[:left] - 1
    top  = coords[:top]  - 1
    
    figure_pixels = []
    
    move(c, r, pixels, columns, rows, left, top, figure_pixels, width, height)
    
    [figure_pixels, width, height]
  end
  
  def move(c, r, pixels, columns, rows, left, top, figure_pixels, width, height)
    
    stack = [[c, r]]
    while !stack.empty?
      params = stack.delete_at(0)
      x = params[0]
      y = params[1]
      
      p = position(x, y, columns, rows)
      if p and pixels[p]
        pixels[p] = false
        f_p = position(x - left, y - top, width, height)
        figure_pixels[f_p] = true if f_p
        
        add_new_params(stack, x, y)
      end
    end
  end
  
  def find_coords(c, r, pixels, columns, rows)
    result = {
      :right  => c,
      :left   => c,
      :top    => r,
      :bottom => r
    }
    
    stack = [[c, r]]
    while !stack.empty?
      params = stack.delete_at(0)
      x = params[0]
      y = params[1]
      
      p = position(x, y, columns, rows)
      if p and pixels[p]
        pixels[p] = false
        
        calc_coords(result, {
          :right  => x,
          :left   => x,
          :top    => y,
          :bottom => y
        })
        
        add_new_params(stack, x, y)
      end
    end
    result
  end
  
  def calc_coords(c1, c2)
    c1[:left]   = c2[:left]   if c2[:left]   < c1[:left]
    c1[:right]  = c2[:right]  if c2[:right]  > c1[:right]
    c1[:top]    = c2[:top]    if c2[:top]    < c1[:top]
    c1[:bottom] = c2[:bottom] if c2[:bottom] > c1[:bottom]
  end
  
end
