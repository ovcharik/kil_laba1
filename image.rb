require 'RMagick'

class Image
  
  attr_reader :pixels, :rows, :columns, :path
  
  def initialize(img, path)
    @path    = path
    @rows    = img.rows
    @columns = img.columns
    
    @pixels = []
    img.each_pixel do |pixel, column, row|
      @pixels << normalize(pixel)
    end
  end
  
  private
  
  def normalize(pixel)
    if (pixel.red <= 0x88 or pixel.green <= 0x88 or pixel.blue <= 0x88) and pixel.opacity <= 0x88
      true
    else
      false
    end
  end
  
end
