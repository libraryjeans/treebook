require 'test_helper'

class UserTest < ActiveSupport::TestCase

  should have_many(:user_friendships)
  should have_many(:friends)

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
  	user = User.new(first_name: 'genius', last_name: 'genius', email: 'genius@genius.com') 
    user.password = user.password_confirmation = '123456'
  	assert !user.save #make sure it can't be saved
  	assert !user.errors[:profile_name].empty? #make sure there are errors in the profile name
  	# puts user.errors.inspect #debug - prints out errors before failur msg
  	assert user.errors[:profile_name].include?('must be formatted correctly.') #make sure we are getting correct msg
  end

  test "a user can have a correctly formatted profile name" do
    user = User.new(first_name: 'genius', last_name: 'genius', email: 'genius1@genius.com') 
    user.password = user.password_confirmation = '123456'
    user.profile_name = 'genius1'
    assert user.valid?
  end

  test "that no error is raised when trying to access a friend list" do
    assert_nothing_raised do
      users(:laura).friends
    end
  end

  # this errors
  test "that creating friendships on a user works" do
    users(:laura).friends << users(:genius)#adding genius as friend
    users(:laura).friends.reload #reloads friends in database
    assert users(:laura).friends.inlcude?(users(:genius))
  end

  test "that calling to_param on a user returns the profile_name" do 
    assert_equal "libraryjeans", users(:laura).to_param
  end

end
