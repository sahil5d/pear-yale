class AddUserIdToOpenings < ActiveRecord::Migration
  def change
    add_column :openings, :user_id, :integer
  end
end