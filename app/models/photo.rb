class Photo < ApplicationRecord
  attr_accessor :x, :y, :w, :h, :file_name
  has_many :boat_photos, dependent: :delete_all
  has_many :boat_types, through: :boat_photos
  
  before_save :makeNewFileName
  mount_uploader :link, PhotoUploader
  
  def hash_view(is_wide=false)
    if is_wide
      {
        id: self.id,
        wide_small: link.wide_small.url,
        wide_medium: link.wide_medium.url,
        wide_large: link.wide_large.url
      }
    else
      {
        id: self.id,
        thumb: link.thumb.url,
        small: link.small.url,
        medium: link.medium.url,
        large: link.large.url
      }
    end
    
  end
  
  
	def cropPhotoForSlider
    xlarge_path = self.link.wide_xlarge
		large_path = self.link.wide_large
		medium_path = self.link.wide_medium
		small_path = self.link.wide_small
		ph = Magick::ImageList.new(Rails.root.join("public#{self.link}"))
		resized = ph.crop(self.x, self.y, self.w, self.h)
		resized = resized.resize(2000, 500)
		resized.write(Rails.root.join("public#{xlarge_path}"))
		resized = resized.resize(1600, 400)
		resized.write(Rails.root.join("public#{large_path}"))
		resized = resized.resize(1200, 300)
		resized.write(Rails.root.join("public#{medium_path}"))
		resized = resized.resize(800, 200)
		resized.write(Rails.root.join("public#{small_path}"))
	end
  
  private
  
	def makeNewFileName
		self.file_name = SecureRandom.hex(7) if new_record?
	end
end
