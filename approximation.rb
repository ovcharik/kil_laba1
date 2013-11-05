require './settings.rb'

require './line.rb'

class Approximation
  
  attr_reader :nodes, :lines, :angles
  
  def initialize(nodes)
    @split_radius = SETTINGS["approximation"]["point_split_radius"]
    @min_angle = SETTINGS["approximation"]["min_angle_deg"]
    
    @nodes  = compact(nodes)
    @lines  = create_lines
    @angles = create_angles
  end
  
  private
  
  def compact(nodes)
    result = []
    nodes.each do |node|
      unless result.inject(false){ |f, v| f ||= node_around?(node, v) }
        result << node
      end
    end
    
    flag = true
    while flag
      flag = false
      if result.count > 2
        curr = result.last
        i = 0
        while i < (result.count - 1)
          prev = curr
          curr = result[i]
          nexy = result[i + 1]
          
          line1 = Line.new(prev, curr)
          line2 = Line.new(curr, nexy)
          
          if Line.angle(line1, line2, true) < @min_angle
            result.delete_at(i)
            flag = true
            break
          end
          i += 1
        end
      end
    end
    result
  end
  
  def node_around?(node1, node2)
    ((node1[0] - node2[0])**2 + (node1[1] - node2[1])**2) < @split_radius**2
  end
  
  def create_lines
    lines = []
    curr = @nodes.last
    @nodes.each do |node|
      prev = curr
      curr = node
      lines << Line.new(prev, curr)
    end
    lines
  end
  
  def create_angles
    return [] if @lines.count < 2
    
    angles = []
    curr = @lines.last
    @lines.each do |line|
      prev = curr
      curr = line
      angles << Line.angle(prev, curr)
    end
    angles
  end
  
end
