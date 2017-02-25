class Trademark < ApplicationRecord
  attr_accessor :logo_cache, :vertical_logo_cache, :white_logo_cache
  belongs_to :creator, class_name: "User" #кто создал
  belongs_to :updater, class_name: "User" #кто изменил
  
  has_many :boat_types, dependent: :destroy

  mount_uploader :logo, LogoUploader
  mount_uploader :vertical_logo, LogoUploader
  mount_uploader :white_logo, LogoUploader
end
