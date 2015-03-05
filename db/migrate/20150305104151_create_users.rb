class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |u|
      u.string  :username
      u.string  :encrypted_password
      u.string  :first_name
      u.string  :last_name
      u.string  :full_name
      u.string  :access
    end
  end
end
