require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # set up test data for table user
  fixtures :users
  
  test "user attributes must not be empty" do
     user = User.new
     assert user.invalid?
     assert user.errors[:firstname].any?
     assert user.errors[:lastname].any?
     assert user.errors[:email].any?
     assert user.errors[:password].any?
     assert user.errors[:state].any?
  end
  
  test "user email must be unique" do
    user = User.new(:email => users(:one).email,
                    :firstname => "Martin",
                    :lastname => "Schmidt",
                    :password => "23456",
                    :state => "active")
    assert !user.save
    assert_equal I18n.translate('activerecord.errors.messages.taken'), user.errors[:email].join('; ')
  end
end
