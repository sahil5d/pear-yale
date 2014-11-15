class AddDatetimeToOpenings < ActiveRecord::Migration
  def change
  	 add_column :openings, :date_time, :datetime
  end
end
