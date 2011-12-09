class SwapProvider < ActiveRecord::Base
  belongs_to :compact_disk
  belongs_to :transaction
end
