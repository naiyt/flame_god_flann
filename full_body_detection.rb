require 'opencv'
include OpenCV

if ARGV.length < 2
  puts "Usage: ruby #{__FILE__} source dest"
  exit
end

data = './opencv/data/haarcascades/haarcascade_upperbody.xml'
detector = CvHaarClassifierCascade::load(data)
image = CvMat.load(ARGV[0])
color = CvColor::Blue

detector.detect_objects(image).each do |region|
  image.rectangle! region.top_left, region.bottom_right, color: color
end

image.save_image(ARGV[1])
exec "open #{ARGV[1]}"
