# This migration comes from marduk_engine (originally 20170608140144)
class AddTokenToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :token, :string
  end
end
