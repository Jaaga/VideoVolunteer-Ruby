class CreateCcs < ActiveRecord::Migration
  def change
    create_table :ccs do |c|
      c.string :full_name
      c.string :first_name,      null: false
      c.string :last_name,       null: false
      c.string :state_abb,       null: false
      c.string :state,           null: false
      c.string :district,        null: false
      c.string :phone
      c.string :mentor,          null: false
      c.string :notes
    end
  end
end
