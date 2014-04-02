class AddCommentToSwimmers < ActiveRecord::Migration
  def change
    add_column :swimmers, :comment, :text
  end
end
