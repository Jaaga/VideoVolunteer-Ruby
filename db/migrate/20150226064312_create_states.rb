class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |s|
      s.string :state,      null: false, unique: true
      s.string :state_abb,  null: false, unique: true
      s.string :district
    end
  end
end
