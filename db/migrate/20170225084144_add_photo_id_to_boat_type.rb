class AddPhotoIdToBoatType < ActiveRecord::Migration[5.0]
  def change
    add_column :boat_types, :photo_id, :integer
  end
end
