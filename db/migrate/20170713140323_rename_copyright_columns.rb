class RenameCopyrightColumns < ActiveRecord::Migration[5.0]
  def change
    rename_column :subjects, :copyright_owner, :file_copyright
    rename_column :subjects, :copyright_license, :file_copyright_details
  end
end
