class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |s|
      s.string :state
      s.string :state_abb
      s.string :district
    end
  end
end
