require './settings.rb'

require './figure.rb'

class FigureChecker
  
  def self.get_info(figure)
    
    error = SETTINGS["checker"]["error"]
    pass_percent = SETTINGS["checker"]["pass_percent"]
    
    type   = "Unknow"
    accord = 1
    
    width  = figure.columns
    height = figure.rows
    
    approximation = figure.approximation
    
    angles = approximation.angles
    lines  = approximation.lines
    nodes  = approximation.nodes
    
    nodes_count  = nodes.count
    angles_count = angles.count
    angles_summ  = angles.inject(0){ |summ, v| summ += v }
    lines_length = lines.inject(0){|f, v| f += v.length}
    space        = figure.space
    fill_space   = figure.fill_space
    
    if nodes_count == 1
      if space >= ((width - 1) * (height - 1) / 2)
        type = "Dot"
      end
    
    elsif nodes_count == 2
      type = "Line"
    
    elsif nodes_count == 3
      s = lines.first.length * lines.last.length * Math.sin(angles.first) / 2
      a = calc_accord(s, fill_space)
      if a >= pass_percent
        accord = a
        type = "Triangle"
      end
    
    elsif nodes_count == 4
      a = 1
      a *= calc_accord(angles_summ, 2 * Math::PI)
      a *= calc_accord((lines[0].length * lines[1].length), fill_space)
      a *= calc_accord(angles, Math::PI / 2)
      
      if a >= pass_percent and check_array(angles, Math::PI / 2, error)
        accord = a
        if check_array(lines.map{ |v| v.length }, (lines_length / 4), error)
          type = "Square"
        else
          type = "Rectangle"
        end
      end
    
    elsif nodes_count > 8
      a = 1
      a *= calc_accord((Math::PI * (width / 2)**2), figure.fill_space)
      if a >= pass_percent and check_value(width, height, error)
        accord = a
        type = "Circle"
      end
    end
    
    "
    type:        #{type}
    accord:      #{(accord * 100).round(2)}%
    fill:        #{figure.fill?}
    rect width:  #{width}
    rect height: #{height}
    
    angles:
        count:     #{angles_count}
        summ:      #{to_deg(angles_summ).round(2)}
        #{angles.map{ |v| to_deg(v).round(2) }.to_s}
    
    lines:
        count:     #{lines.count}
        length:    #{lines_length.round(2)}
        #{lines.map{ |v| v.length.round(2) }.to_s}
    
    nodes:
        count:     #{nodes_count}
        #{nodes.to_s}
    
    space:
        contour:   #{space}
        fill:      #{fill_space}
    "
  end
  
  private
  
  def self.check_array(array, value, error)
    array.inject(true) do |result, v|
      result &&= check_value(v, value, error)
    end
  end
  
  def self.check_value(value, true_value, error)
    (value - true_value).abs <= error
  end
  
  def self.calc_accord(value, true_value)
    if value.is_a? Array
      summ = value.inject(0) do |s, v|
        s += (v - true_value)**2
      end
      1 - Math.sqrt(summ / value.count) / true_value
    else
      1 - (true_value - value).abs / true_value
    end
  end
  
  def self.to_deg(rad)
    rad / Math::PI * 180
  end
  
end
