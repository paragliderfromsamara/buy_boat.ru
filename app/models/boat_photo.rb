class BoatPhoto < ApplicationRecord
  belongs_to :boat_type
  belongs_to :photo
end
