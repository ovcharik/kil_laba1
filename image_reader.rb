require 'RMagick'

require './image.rb'

class ImageReader
  
  attr_reader :images
  
  def initialize(dir_name)
    @images = []
    
    if Dir.exist? dir_name
      Dir.foreach dir_name do |file_name|
        if file_name =~ /\.(jpg|jpeg|png|gif|png|bmp)$/
          f = File.join(dir_name, file_name)
          @images << Image.new(Magick::ImageList.new(f), f.to_s)
        end
      end
    else
      raise "Dir not found"
    end
  end
  
end
