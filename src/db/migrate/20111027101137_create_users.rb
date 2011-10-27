class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :role_id
      
      t.string :alias
      t.string :lastname
      t.string :firstname
      t.string :email
      t.string :password
      t.string :image_uri
      t.string :state
      
      t.timestamps
    end
  end
end
