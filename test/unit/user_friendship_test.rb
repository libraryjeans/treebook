require 'test_helper'

class UserFriendshipTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:friend)

  test "that create a friendship works without raising an exception" do
  	assert_nothing_raised do
  		UserFriendship.create user: users(:laura), friend: users(:daffy)
  	end
  end

  test "that creates a friendship based on user id and friend id works" do
  	UserFriendship.create user_id: users(:laura).id, friend_id: users(:genius).id
  	assert users(:laura).friends.include?(users(:genius))
  end	
end
