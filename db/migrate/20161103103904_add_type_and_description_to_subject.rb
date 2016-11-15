class AddTypeAndDescriptionToSubject < ActiveRecord::Migration[5.0]
  def change
    add_column :subjects, :type, :string
    add_column :subjects, :description, :text
  end
end
