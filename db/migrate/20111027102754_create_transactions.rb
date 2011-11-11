class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :provider_id
      t.integer :receiver_id
      t.integer :provider_disk_id
      t.integer :receiver_disk_id
      
      t.string :state

      t.timestamps
    end
  end
end
