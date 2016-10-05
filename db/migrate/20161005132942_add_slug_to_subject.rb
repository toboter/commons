class AddSlugToSubject < ActiveRecord::Migration[5.0]
  def change
    add_column :subjects, :slug, :string
    add_index :subjects, :slug, unique: true
  end
end
