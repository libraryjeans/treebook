require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user should enter first name" do
  	user = User.new #creating new user variable
    assert !user.save #asserting user should not be saved 
  	assert !user.errors[:first_name].empty? #asserting errors on first_name not empty
  end 

  test "user should enter last name" do
  	user = User.new #creating new user variable
    assert !user.save #asserting user should not be saved 
  	assert !user.errors[:last_name].empty? #asserting errors on last_name not empty
  end 

  test "user should enter profile name" do
  	user = User.new #creating new user variable
    assert !user.save #asserting user should not be saved 
  	assert !user.errors[:profile_name].empty? #asserting errors on profile_name not empty
  end

  test "user should have unique profile name" do
  	user = User.new #creating new user variable
  	user.profile_name = 'genius'
    assert !user.save #asserting user should not be saved 
  	# puts user.errors.inspect #debug - prints out errors before failur msg
  	assert !user.errors[:profile_name].empty? #asserting errors on profile_name not unique
  end

  test "a user should have a profile name without spaces" do
  	user = User.new # new user instance
  	user.profile_name = 'My Profile With Spaces'
  	assert !user.save #make sure it can't be saved
  	assert !user.errors[:profile_name].empty? #make sure there are errors in the profile name
  	puts user.errors.inspect #debug - prints out errors before failur msg
  	assert user.errors[:profile_name].include?('must be formatted correctly.') #make sure we are getting correct msg
  end
end
