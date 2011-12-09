class CreateSwapReceivers < ActiveRecord::Migration
  def change
    create_table :swap_receivers do |t|
      t.references :compact_disk
      t.references :transaction

      t.timestamps
    end
  end
end
