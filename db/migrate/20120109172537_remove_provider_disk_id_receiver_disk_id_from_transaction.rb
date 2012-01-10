class RemoveProviderDiskIdReceiverDiskIdFromTransaction < ActiveRecord::Migration
  def up
    remove_column :transactions, :provider_disk_id
    remove_column :transactions, :receiver_disk_id
  end

  def down
    add_column :transactions, :receiver_disk_id, :integer
    add_column :transactions, :provider_disk_id, :integer
  end
end
