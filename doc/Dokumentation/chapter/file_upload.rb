has_attached_file :photo, :styles => { :normal => "150x150>", :small => "70x70>" },
 :url  => "/system/users/:id/:style/:basename.:extension", 
 :path => ":rails_root/public/system/users/:id/:style/:basename.:extension",
 :default_url => "/assets/user_default_:style.png"

validates_attachment_size :photo, :less_than => 5.megabytes
validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

t.string   "photo_file_name"
t.string   "photo_content_type"
t.integer  "photo_file_size"