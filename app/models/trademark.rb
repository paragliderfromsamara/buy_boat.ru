class Trademark < ApplicationRecord
  belongs_to :creator, class_name: "User" #кто создал
  belongs_to :updater, class_name: "User" #кто изменил
  
  has_many :boat_types, dependent: :destroy

end
