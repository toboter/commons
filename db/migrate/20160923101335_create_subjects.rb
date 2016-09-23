class CreateSubjects < ActiveRecord::Migration[5.0]
  def change
    create_table :subjects do |t|
      t.string :name
      t.string :attachment
      t.string :content_type
      t.string :copyright_owner
      t.string :copyright_license

      t.timestamps
    end
  end
end
