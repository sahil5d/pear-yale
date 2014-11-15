class CreateOpenings < ActiveRecord::Migration
  def change
    create_table :openings do |t|
      t.string :place
      t.integer :weekday
      t.integer :minuteTime

      t.timestamps
    end
  end
end
