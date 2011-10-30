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
                    :firstname => users(:one).firstname,
                    :lastname => users(:one).lastname,
                    :password => users(:one).password,
                    :state => users(:one).state)
    assert !user.save
    assert_equal I18n.translate('activerecord.errors.messages.taken'), user.errors[:email].join('; ')
  end
  
  test "invalid image uri" do
    user = User.new(:email => "test@test.com",
                    :firstname => users(:one).firstname,
                    :lastname => users(:one).lastname,
                    :password => users(:one).password,
                    :state => users(:one).state,
                    :image_uri => "image.sh")
    assert user.invalid?
  end
  
  test "valid image uri" do
    user = User.new(:email => "test@test.com",
                    :firstname => users(:one).firstname,
                    :lastname => users(:one).lastname,
                    :password => users(:one).password,
                    :state => users(:one).state,
                    :image_uri => "image.png")
    assert user.valid?
  end
  
  test "valid email pattern" do
    user = User.new(:firstname => users(:one).firstname,
                    :lastname => users(:one).lastname,
                    :email => "hans.peter@google.com",
                    :password => users(:one).password,
                    :state => users(:one).state,
                    :image_uri => users(:one).image_uri)
    assert user.valid?
  end
  
  test "invalid email pattern" do
    user = User.new(:firstname => users(:one).firstname,
                    :lastname => users(:one).lastname,
                    :password => users(:one).password,
                    :state => users(:one).state,
                    :image_uri => users(:one).image_uri)
    
    user.email = "@me.com"
    assert user.invalid?, "Should fail due starts with an @ sign"
                    
    user.email = "testme.com"
    assert user.invalid?, "Should fail due to missing @ sign"
    
    user.email = "test@mecom"
    assert user.invalid?, "Should fail due to missing . sign in domain part"
    
    user.email = "test@me."
    assert user.invalid?, "Should fail due no top-level domain is given"
    
    user.email = "test@"
    assert user.invalid?, "Should fail due no domain is given"
    
  end
end
