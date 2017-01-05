# Adapted from the tutorial here: https://github.com/ruby-opencv/ruby-opencv

require 'opencv'
include OpenCV

def load_image(path)
  CvMat.load(path, CV_LOAD_IMAGE_COLOR)
rescue
  puts "Image not found"
  exit
end

def display_image(image)
  window = GUI::Window.new('Display window')
  window.show(image)
  GUI::wait_key
end

if ARGV.size == 0
  puts "Usage: ruby #{__FILE__} ImageToLoadAndDisplay"
  exit
end

image = load_image(ARGV[0])
display_image(image)
