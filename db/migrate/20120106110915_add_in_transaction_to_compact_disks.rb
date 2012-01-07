class AddInTransactionToCompactDisks < ActiveRecord::Migration
  def change
    add_column :compact_disks, :inTransaction, :boolean, :default => false
  end
end
