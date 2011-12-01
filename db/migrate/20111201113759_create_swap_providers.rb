class CreateSwapProviders < ActiveRecord::Migration
  def change
    create_table :swap_providers do |t|
        t.integer :CompactDisk_id
        t.integer :Transaction_id

      t.timestamps
    end
  end
end
