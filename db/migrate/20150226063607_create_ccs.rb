class CreateCcs < ActiveRecord::Migration
  def change
    create_table :ccs do |c|
      c.string :full_name
      c.string :first_name
      c.string :last_name
      c.string :state_abb
      c.string :state
      c.string :district
      c.string :phone
      c.string :mentor
      c.string :notes
    end
  end
end
