# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end
  
  
	version :large do
		process :resize_to_fit => [1400, 1080]
	end
  
	version :medium, from_version: :large do
		process :resize_to_fit => [800, 600]
	end

	version :small, from_version: :medium do
		process :resize_to_fit => [600, 450]
	end
  
	version :thumb_square, from_version: :small  do
		process :resize_to_fill => [300, 300]
	end
  
	version :thumb do
		process :resize_to_fit => [300, 200]
	end
  
  
	version :wide_large do
		process :resize_to_fill => [1400, 500]
	end
	
	version :wide_medium, from_version: :wide_large do
		process :resize_to_fit => [1008, 360]
	end
	
	version :wide_small, from_version: :wide_medium do
		process :resize_to_fit => [784, 280]
	end
	
  def filename
    "#{model.file_name}.jpg" if original_filename
  end
  
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
