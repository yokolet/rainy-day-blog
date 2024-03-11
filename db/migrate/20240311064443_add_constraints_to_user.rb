class AddConstraintsToUser < ActiveRecord::Migration[7.1]
  def change
    change_column_null(:users, :provider, false)
    change_column_null(:users, :identifier, false)
    add_index :users, [:identifier, :provider], unique: true
  end
end
