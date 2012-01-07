class OldAudioFilename < ActiveRecord::Migration
  def up
     add_column :compact_disks, :last_audio_file_name, :string, :default => ""
  end

  def down
     remove_column :compact_disks, :last_audio_file_name, :string
  end
end
