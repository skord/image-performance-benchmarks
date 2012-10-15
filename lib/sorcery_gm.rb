require 'image_sorcery'
require 'fileutils'

class SorceryGM
  attr_accessor :image

  def initialize(input_image_file_path, output_image_file_path)
    FileUtils.cp(input_image_file_path, output_image_file_path)
    @image = Sorcery.gm output_image_file_path
  end

  def resize_to_fit(width, height)
    manipulate! do |img|
      img.manipulate!(resize: "#{width}x#{height}")
      img = yield(img) if block_given?
      img
    end
  end

  def resize_to_fill(width, height, gravity = 'Center')
    manipulate! do |img|
      cols, rows = img.dimensions[:x].to_i, img.dimensions[:y].to_i
      opt={}
      if width != cols || height != rows
        scale = [width/cols.to_f, height/rows.to_f].max
        cols  = (scale * (cols + 0.5)).round
        rows  = (scale * (rows + 0.5)).round
        opt[:resize] = "#{cols}x#{rows}"
      end
      opt[:gravity] = gravity
      opt[:background] = "rgba(255,255,255,0.0)"
      opt[:extent] = "#{width}x#{height}" if cols != width || rows != height
      img.manipulate!(opt)
      img = yield(img) if block_given?
      img
    end
  end

  def resize_and_pad(width, height, background=:transparent, gravity='Center')
    manipulate! do |img|
      opt={}
      opt[:thumbnail] = "#{width}x#{height}"
      background == :transparent ? opt[:background] = "rgba(255, 255, 255, 0.0)" : opt[:background] = background
      opt[:gravity] = gravity
      opt[:extent] = "#{width}x#{height}"
      img.manipulate!(opt)
      img = yield(img) if block_given?
      img
    end
  end

  def dimensions
    manipulate! do |img|
      img.dimensions
    end
  end

  def manipulate!
    @image = yield(@image)
  end
end