class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |u|
      u.string  :email,               null: false, unique: true
      u.string  :encrypted_password,  null: false
      u.string  :first_name,          null: false
      u.string  :last_name,           null: false
      u.string  :full_name
      u.string  :access
    end
  end
end
