class AddColumnsToSubject < ActiveRecord::Migration[5.0]
  def change
    add_column :subjects, :attachment_size, :string
    add_column :subjects, :attachment_created_at, :string
    add_column :subjects, :attachment_original_filename, :string
  end
end
