require 'benchmark'
require 'bundler'
Bundler.require

load "./lib/mini_magick_im.rb"

IMAGE_FILE= File.expand_path('DSCN1962.jpg')
RESIZE_WIDTH= 100
RESIZE_HEIGHT= 100
RESIZE_SIZE= "#{RESIZE_WIDTH}x#{RESIZE_HEIGHT}"
RUNS = 100
LINE = '---------------------------------------------------------------------'



def image_extension(image_file_path)
  File.extname(image_file_path)
end

def image_filename(image_file_path)
  File.basename(image_file_path).gsub(image_extension(image_file_path),'')
end

puts LINE
puts "Profiling MiniMagick Resize to Fit (ImageMagick): #{RUNS} runs"
result = RubyProf::Profile.profile do
  RUNS.times do |i|
    input_file_path = IMAGE_FILE
    output_file_path = "tmp/#{image_filename(input_file_path)}_#{i.to_s}#{image_extension(input_file_path)}"
    MiniMagickIM.new(input_file_path, output_file_path).resize_to_fit(RESIZE_WIDTH,RESIZE_HEIGHT)
  end
end
File.open "reports/mini_magick-im/resize-to-fit.html", 'w' do |file|
  RubyProf::GraphHtmlPrinter.new(result).print(file)
end

puts LINE
puts "Profiling MiniMagick Resize to Fill (ImageMagick): #{RUNS} runs"
result = RubyProf::Profile.profile do
  RUNS.times do |i|
    input_file_path = IMAGE_FILE
    output_file_path = "tmp/#{image_filename(input_file_path)}_#{i.to_s}#{image_extension(input_file_path)}"
    MiniMagickIM.new(input_file_path, output_file_path).resize_to_fill(RESIZE_WIDTH,RESIZE_HEIGHT)
  end
end
File.open "reports/mini_magick-im/resize-to-fill.html", 'w' do |file|
  RubyProf::GraphHtmlPrinter.new(result).print(file)
end

puts LINE
puts "Profiling MiniMagick Resize and Pad (ImageMagick): #{RUNS} runs"
result = RubyProf::Profile.profile do
  RUNS.times do |i|
    input_file_path = IMAGE_FILE
    output_file_path = "tmp/#{image_filename(input_file_path)}_#{i.to_s}#{image_extension(input_file_path)}"
    MiniMagickIM.new(input_file_path, output_file_path).resize_and_pad(RESIZE_WIDTH,RESIZE_HEIGHT)
  end
end
File.open "reports/mini_magick-im/resize-and-pad.html", 'w' do |file|
  RubyProf::GraphHtmlPrinter.new(result).print(file)
end

puts LINE
puts "Profiling MiniMagick GIF Collapse (ImageMagick): #{RUNS} runs"
result = RubyProf::Profile.profile do
  RUNS.times do |i|
    input_file_path = IMAGE_FILE
    output_file_path = "tmp/#{image_filename(input_file_path)}_#{i.to_s}#{image_extension(input_file_path)}"
    MiniMagickIM.new(input_file_path, output_file_path).collapse_gif
  end
end
File.open "reports/mini_magick-im/gif-collapse.html", 'w' do |file|
  RubyProf::GraphHtmlPrinter.new(result).print(file)
end