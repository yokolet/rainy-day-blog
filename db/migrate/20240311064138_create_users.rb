class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :identifier
      t.string :name
      t.integer :provider
      t.string :token
      t.datetime :token_expiry

      t.timestamps
    end
  end
end
