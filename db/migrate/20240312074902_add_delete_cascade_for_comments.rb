class AddDeleteCascadeForComments < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :comments, :posts
    add_foreign_key :comments, :posts, on_delete: :cascade
    remove_foreign_key :comments, :users
    add_foreign_key :comments, :users, on_delete: :cascade
  end
end
