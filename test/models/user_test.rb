require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

    test "incorrect email and pswd combination" do
  	user = User.create(
  		email: "example@gmail.com",
  		password: "abc123"
  	)

  	assert_not user.valid_password?("123456")
  end


  test "email format invalid" do
  	user = User.new(
  		email: "thisIsNotEmail",
  		password: "abc123"
  	)
  	assert user.invalid?
  end

  
  test "short password length" do
  	user = User.new(
  		email: "example1@gmail.com",
  		password: "12345"
  	)
	assert user.invalid?
  end

end
