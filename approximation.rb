require './settings.rb'

require './line.rb'

class Approximation
  
  attr_reader :nodes, :lines, :angles
  
  def initialize(nodes)
    @split_radius = SETTINGS["approximation"]["point_split_radius"]
    
    @nodes  = first_compact(nodes)
    @lines  = create_lines
    @angles = create_angles
  end
  
  private
  
  def first_compact(nodes)
    r = []
    if !nodes.empty?
      r << nodes.delete_at(0)
      while !nodes.empty?
        n = nodes.delete_at(0)
        unless r.inject(false){ |f, v| f ||= node_around?(n, v) }
          r << n
        end
      end
    end
    r
  end
  
  def node_around?(node1, node2)
    ((node1[0] - node2[0])**2 + (node1[1] - node2[1])**2) < @split_radius**2
  end
  
  def create_lines
    lines = []
    n = @nodes.dup
    
    first = n.delete_at(0)
    current = first
    
    while !n.empty?
      prev = current
      current = n.delete_at(0)
      lines << Line.new(prev, current)
    end
    if @nodes.count > 2
      lines << Line.new(first, current)
    end
    lines
  end
  
  def create_angles
    angles = []
    return angles if @lines.length < 2
    
    l = @lines.dup
    first = l.delete_at(0)
    current = first
    
    while !l.empty?
      prev = current
      current = l.delete_at(0)
      angles << Line.angle(prev, current)
    end
    angles << Line.angle(first, current)
    angles
  end
  
end
