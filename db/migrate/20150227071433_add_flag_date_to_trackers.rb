class AddFlagDateToTrackers < ActiveRecord::Migration
  def change
    add_column :trackers, :flag_date, :date
  end
end
