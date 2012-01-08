class ChangeColumnName < ActiveRecord::Migration
  def up
    rename_column :compact_disks, :inTransaction, :in_transaction
  end

  def down
    rename_column :compact_disks, :in_transaction, :inTransaction
  end
end
