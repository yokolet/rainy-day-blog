class AddSelfJoinReferencesToComment < ActiveRecord::Migration[7.1]
  def change
    add_reference(:comments, :reply, foreign_key: { to_table: :comments }, index: false)
  end
end
