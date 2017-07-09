class AddShrine < ActiveRecord::Migration[5.0]
  def change
    add_column :subjects, :file_data, :text
    remove_column :subjects, :attachment, :string
    remove_column :subjects, :attachment_size, :string
    remove_column :subjects, :attachment_created_at, :string
    remove_column :subjects, :attachment_original_filename, :string
    remove_column :subjects, :width, :string
    remove_column :subjects, :height, :string
  end                                         
end