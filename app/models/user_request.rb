class UserRequest < ApplicationRecord
  belongs_to :user
  belongs_to :boat_for_sale
end
