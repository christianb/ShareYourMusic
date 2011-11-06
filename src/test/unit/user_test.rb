require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # set up test data for table user
  fixtures :roles, :users
  
  def setup
    @user = users(:peter)
  end
  
  def teardown
    @user = nil
  end
  
  test "user attributes must not be empty" do
     user = User.new
     assert user.invalid?
     assert user.errors[:firstname].any?
     assert user.errors[:lastname].any?
     assert user.errors[:email].any?
     assert user.errors[:password].any?
  end
  
  test "email" do
    @user.email = nil
    assert @user.invalid?, "email must exist"
  end
  
  test "user email must be unique" do  
    user = User.new(:email => users(:peter).email,
                    :firstname => "vorname",
                    :lastname => "nachname",
                    :password => "abcde",
                    :state => "active")
    assert !user.save
    assert_equal I18n.translate('activerecord.errors.messages.taken'), user.errors[:email].join('; ')
  end
  
  test "image uri" do
    @user.image_uri = "image.sh"
    assert @user.invalid?, "image uri should be invalid"
    
    @user.image_uri = "image.png"
    assert @user.valid?, "image uri should be valid"
    
    # FAILS
    # FIX TEST !!!
    @user.image_uri = nil
    assert @user.valid?, "image uri is allowed to be nil"
  end
  
  test "email pattern" do
    @user.email = "name@domain.com"
    assert @user.valid?, "email pattern should be valid"
    
    @user.email = "@me.com"
    assert @user.invalid?, "Should fail due starts with an @ sign"
                    
    @user.email = "testme.com"
    assert @user.invalid?, "Should fail due to missing @ sign"
    
    @user.email = "test@mecom"
    assert @user.invalid?, "Should fail due to missing . sign in domain part"
    
    @user.email = "test@me."
    assert @user.invalid?, "Should fail due no top-level domain is given"
    
    @user.email = "test@"
    assert @user.invalid?, "Should fail due no domain is given"
  end
  
  test "role id must exist to create new user" do
    @user.email = "abc@htw.de"
    @user.role_id = 0
    assert @user.save, "Should save user due role_id exist"
    
    @user.email = "abcd@htw.de"
    @user.role_id = 42
    assert !@user.save, "should not save user due role_id does not exist"
  end
  
end
