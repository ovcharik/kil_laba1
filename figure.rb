require './settings.rb'

require './approximation'

require './includes/position'
require './includes/stack_params'
require './includes/round'

class Figure
  include Position
  include StackParams
  include Round
  
  attr_reader :pixels, :rows, :columns, :approximation
  
  def initialize(pixels, columns, rows)
    @pixels, @columns, @rows = pixels, columns, rows
    check_fill
    create_contour
    find_nodes
    @approximation = Approximation.new(@nodes)
  end
  
  def fill?
    check_fill if @fill.nil?
    @fill
  end
  
  def space
    calc_space if @space.nil?
    @space
  end
  
  def fill_space
    calc_space if @fill_space.nil?
    @fill_space
  end
  
  private
  
  def check_fill
    stack = [[0, 0]]
    while !stack.empty?
      params = stack.delete_at(0)
      x = params[0]
      y = params[1]
      
      p = position(x, y, @columns, @rows)
      if p and pixels[p].nil?
        pixels[p] = false
        add_new_params(stack, x, y, true)
      end
    end
    
    if pixels.include?(nil)
      @fill = false
      @pixels_fill = @pixels.map{ |x| x.nil? ? true : x }
    else
      @fill = true
      @pixels_fill = @pixels
    end
  end
  
  def calc_space
    @fill_space = @space = @pixels.count(true)
    if not fill?
      @fill_space = @pixels_fill.count(true)
    end
  end
  
  def create_contour
    @pixels_contour = []
    for y in (0...@rows)
      for x in (0...@columns)
        p = position(x, y, @columns, @rows)
        @pixels_contour[p] = false if p
        if p and @pixels_fill[p]
          f = 0
          ps = [
            position(x - 0, y - 1, @columns, @rows),
            position(x - 1, y - 0, @columns, @rows),
            position(x + 1, y - 0, @columns, @rows),
            position(x - 0, y + 1, @columns, @rows)
          ]
          if ps.count{ |a| a and @pixels_fill[a] } < 4
            @pixels_contour[p] = true
          end
        end
      end
    end
  end
  
  # Очень долгое место, нужно что-то придумать
  def find_nodes
    
    radius = SETTINGS["approximation"]["point_find_radius"]
    error  = SETTINGS["approximation"]["gradient_max_error"]
    
    @nodes = []
    checked = []
    
    p = @pixels_contour.index(true)
    start = p
    
    prev  = nil
    dprev = nil
    
    begin
      curr = from_position(p, @columns, @rows)
      x = curr[0]
      y = curr[1]
      
      checked << curr
      
      if prev.nil?
        @nodes << curr
        @pixels_contour[p] = 'x'
      else
        dx = prev[0] - x
        dy = prev[1] - y
        dcurr = [dx, dy]
        if !dprev
          dprev = dcurr
        elsif ((dprev[0] - dcurr[0])**2 + (dprev[1] - dcurr[1])**2) > error
          @nodes << curr
          @pixels_contour[p] = 'x'
          dprev = dcurr
        end
      end
      
      p = nil
      round_dotes(x, y, radius).each do |d|
        flag = false
        checked.each do |node|
          flag ||= round_include?(d[0], d[1], node[0], node[1], radius)
          break if flag
        end
        pos = position(d[0], d[1], @columns, @rows)
        if !flag and pos and @pixels_contour[pos]
          p = pos
          break
        end
      end
      prev = curr
    end until !p
  end
  
end
