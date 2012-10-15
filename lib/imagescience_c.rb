class ImagescienceC

  attr_accessor :input_image_file_path, :output_image_file_path
  def initialize(input_image_file_path, output_image_file_path)
    FileUtils.cp(input_image_file_path, output_image_file_path)
    @output_image_file_path = output_image_file_path
    @input_image_file_path = input_image_file_path
  end


  def resize_to_fit(width, height)
    ImageScience.with_image(@input_image_file_path) do |img|
      img.resize(width, height) do |img2|
        img2.save @output_image_file_path
      end
    end
  end

  def resize_to_fill(width)
    ImageScience.with_image(@input_image_file_path) do |img|
      img.cropped_thumbnail(width) do |img2|
        img2.save @output_image_file_path
      end
    end
  end



end