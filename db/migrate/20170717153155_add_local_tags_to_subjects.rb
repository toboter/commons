class AddLocalTagsToSubjects < ActiveRecord::Migration[5.0]
  def change
    add_column :subjects, :local_tags, :text
    add_index :subjects, :local_tags
  end
end
