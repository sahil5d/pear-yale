class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :lunch_id
      t.integer :user_id

      t.timestamps
    end
  end
end
