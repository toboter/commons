class AddFileSignatureToSubjects < ActiveRecord::Migration[5.0]
  def change
    add_column :subjects, :file_signature, :text
    add_index :subjects, :file_signature, unique: true
  end
end
