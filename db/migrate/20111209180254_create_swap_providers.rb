class CreateSwapProviders < ActiveRecord::Migration
  def change
    create_table :swap_providers do |t|
      t.references :compact_disk
      t.references :transaction
      t.timestamps
    end
  end
end
