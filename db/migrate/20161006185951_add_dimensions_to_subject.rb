class AddDimensionsToSubject < ActiveRecord::Migration[5.0]
  def change
    add_column :subjects, :width, :string
    add_column :subjects, :height, :string
  end
end
