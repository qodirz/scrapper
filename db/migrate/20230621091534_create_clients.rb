class CreateClients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients do |t|
      t.string :username
      t.string :password
      t.string :first_name
      t.string :last_name
      t.integer :point
      t.integer :platform

      t.timestamps
    end
  end
end
