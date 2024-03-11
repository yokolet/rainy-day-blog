class AddTokenConstraintsToUser < ActiveRecord::Migration[7.1]
  def change
    add_index :users, :token, unique: true
  end
end
