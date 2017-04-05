class City < ApplicationRecord
  belongs_to :region
  has_one :country, through: :region
end
