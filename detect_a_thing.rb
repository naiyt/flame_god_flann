require 'opencv'
require 'optparse'
include OpenCV

HAARCASCADES_PATH = "./opencv/data/haarcascades"

options = {}
OptionParser.new do |opts|
  opts.on('-c', '--cascade=CASCADE', 'Haar Cascade filename') { |o| options[:cascade_file] = "#{HAARCASCADES_PATH}/#{o}" }
  opts.on('-o', '--output=OUTPUTFILE', 'Output file (or directory if in directory mode)') { |o| options[:output] = o.chomp('/') }
  opts.on('-i', '--input=INPUTFILE', 'Input file') { |o| options[:input] = o }
  opts.on('-d', '--inputdir=INPUTDIR', 'Input directory') { |o| options[:inputdir] = o }
  opts.on('-h', '--help', 'Help') { |o| puts opts; exit }
end.parse!

def validate_options!(options)
  errors = []

  if !File.file?(options[:cascade_file])
    errors << "Cascade file not found at #{options[:cascade_file]}"
  end

  if options[:input] && options[:inputdir]
    errors << "Only specify one of --input and --inputdir"
  end

  if options[:input] && !File.file?(options[:input])
    errors << "Input file #{options[:input]} not found"
  end

  if options[:inputdir] && !File.exist?(options[:inputdir])
    errors << "Input dir #{options[:inputdir]} not found"
  end

  if options[:inputdir] && !File.exist?(options[:output])
    errors << "Must specify an output dir"
  end

  if errors.length > 0
    puts errors.join("\n")
    exit
  end
end

validate_options!(options)

detector     = CvHaarClassifierCascade::load(options[:cascade_file])
color        = CvColor::Blue

# TODO - only supports jpg files currently
files = options[:inputdir] ? Dir["#{options[:inputdir]}/*jpg"] : [options[:input]]

files.each do |f|
  puts "\nProcessing #{f}"
  image = CvMat.load(f)

  detector.detect_objects(image).each do |region|
    puts "Found match starting at (#{region.x},#{region.y})"
    image.rectangle!(region.top_left, region.bottom_right, color: color)
  end

  output_file = options[:inputdir] ? "#{options[:output]}/#{File.basename(f)}" : options[:output]
  puts "Saving to #{output_file}"
  image.save_image(output_file)
end
