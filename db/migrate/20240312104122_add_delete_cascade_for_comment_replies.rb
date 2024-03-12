class AddDeleteCascadeForCommentReplies < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :comments, :comments, column: "reply_id"
    add_foreign_key :comments, :comments, column: "reply_id", on_delete: :cascade
  end
end
