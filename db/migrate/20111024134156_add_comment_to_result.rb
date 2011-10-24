class AddCommentToResult < ActiveRecord::Migration
  def self.up
    add_column :results, :comment, :string
  end

  def self.down
    remove_column :results, :comment
  end
end
