class Trademark < ApplicationRecord
  attr_accessor :logo_cache, :vertical_logo_cache, :white_logo_cache, :delete_logo
  belongs_to :creator, class_name: "User" #кто создал
  belongs_to :updater, class_name: "User" #кто изменил
  
  before_save :check_logo_del_flag
  
  has_many :boat_types, dependent: :destroy

  mount_uploader :logo, LogoUploader
  mount_uploader :vertical_logo, LogoUploader
  mount_uploader :white_logo, LogoUploader
  
  def hash_view
    {
      id: self.id,
      name: self.name,
      logo: sorted_logo(self.logo),
      vertical_logo: sorted_logo(self.vertical_logo),
      white_logo: sorted_logo(self.white_logo)
    }
  end
  
  private
  #удаление логотипа если пришел флаг
  def check_logo_del_flag
    return if delete_logo.blank?
    case delete_logo
    when 'white_logo'
      self.remove_white_logo!
    when 'vertical_logo'
      self.remove_vertical_logo!
    when 'logo'
      self.remove_logo!
    end
  end
  
  def sorted_logo(l)
    return nil if l.nil?
    return {
      small: l.small.url, 
      medium: l.medium.url,
      large: l.large.url
    }
  end
end
