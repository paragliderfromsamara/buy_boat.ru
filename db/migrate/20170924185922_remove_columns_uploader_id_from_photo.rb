class RemoveColumnsUploaderIdFromPhoto < ActiveRecord::Migration[5.0]
  def change
    remove_column :photos, :uploader_id
  end
end
