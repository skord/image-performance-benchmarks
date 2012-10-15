require 'mini_magick'
require 'fileutils'

class MiniMagickGM

  MiniMagick.processor = :gm

  def initialize(input_image_file_path, output_image_file_path)
    FileUtils.cp(input_image_file_path, output_image_file_path)
    @output_image_file_path = output_image_file_path
    @image = MiniMagick::Image.open output_image_file_path
  end

  def resize_to_fit(width, height)
    manipulate! do |img|
      img.resize "#{width}x#{height}"
      img = yield(img) if block_given?
      img
    end
  end

  def resize_to_fill(width, height, gravity = 'Center')
    manipulate! do |img|
      cols, rows = img[:dimensions]
      img.combine_options do |cmd|
        if width != cols || height != rows
          scale_x = width/cols.to_f
          scale_y = height/rows.to_f
          if scale_x >= scale_y
            cols = (scale_x * (cols + 0.5)).round
            rows = (scale_x * (rows + 0.5)).round
            cmd.resize "#{cols}"
          else
            cols = (scale_y * (cols + 0.5)).round
            rows = (scale_y * (rows + 0.5)).round
            cmd.resize "x#{rows}"
          end
        end
        cmd.gravity gravity
        cmd.background "rgba(255,255,255,0.0)"
        cmd.extent "#{width}x#{height}" if cols != width || rows != height
      end
      img = yield(img) if block_given?
      img
    end
  end


  def resize_and_pad(width, height, background=:transparent, gravity='Center')
    manipulate! do |img|
      img.combine_options do |cmd|
        cmd.thumbnail "#{width}x#{height}>"
        if background == :transparent
          cmd.background "rgba(255, 255, 255, 0.0)"
        else
          cmd.background background
        end
        cmd.gravity gravity
        cmd.extent "#{width}x#{height}"
      end
      img = yield(img) if block_given?
      img
    end
  end

  def collapse_gif
    manipulate! do |img|
      img.collapse!
      img = yield(img) if block_given?
      img
    end
  end

  def manipulate!
    @image = yield(@image)
    @image.write(@output_image_file_path)
    @image = ::MiniMagick::Image.open(@output_image_file_path)
  end

end
