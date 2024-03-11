class AddConstraintsToPost < ActiveRecord::Migration[7.1]
  def change
    change_column_null(:posts, :title, false)
    change_column_null(:posts, :content, false)
    change_column(:posts, :content, :text, limit: 1000)
  end
end
