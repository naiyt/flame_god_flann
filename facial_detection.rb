# Adapted from the sample here: https://github.com/ruby-opencv/ruby-opencv

require 'opencv'
include OpenCV

if ARGV.length < 2
  puts "Usage: ruby #{__FILE__} source dest"
  exit
end

data = './opencv/data/haarcascades/haarcascade_frontalface_alt.xml'
detector = CvHaarClassifierCascade::load(data)
image = CvMat.load(ARGV[0])
color = CvColor::Blue

detector.detect_objects(image).each do |region|
  image.rectangle! region.top_left, region.bottom_right, color: color
end

image.save_image(ARGV[1])
# window = GUI::Window.new('Face detection')
# window.show(image)
# GUI::wait_key
