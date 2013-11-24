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
  	assert users(:laura).pending_friends.include?(users(:genius))
  end

  context "a new instance" do
    setup do
      @user_friendship = UserFriendship.new user: users(:laura), friend: users(:genius)
    end

    should "have a pending state" do
      assert_equal 'pending', @user_friendship.state
    end
  end

  context "#send_request_email" do
    setup do
      @user_friendship = UserFriendship.create user: users(:laura), friend: users(:genius)
    end

    should "send an email" do
      assert_difference 'ActionMailer::Base.deliveries.size', 1 do
        @user_friendship.send_request_email
      end
    end

  end

  context "#accept!" do
    setup do
      @user_friendship = UserFriendship.create user: users(:laura), friend: users(:genius)
    end

    should "set the state to accepted" do
      @user_friendship.accept!
      assert_equal "accepted", @user_friendship.state
    end

    should "send acceptance email" do
      assert_difference 'ActionMailer::Base.deliveries.size', 1 do
        @user_friendship.accept!
      end
    end

    should "include the friend in the list of friends" do
      @user_friendship.accept!
      users(:laura).friends.reload
      assert users(:laura).friends.include?(users(:genius))
    end
  end 

  context ".request" do
    should "create two user friendships" do
      assert_difference 'UserFriendship.count', 2 do
        UserFriendship.request(users(:laura), users(:genius))
      end
    end

    should "send a friend request email" do
      assert_difference 'ActionMailer::Base.deliveries.size', 1 do
        UserFriendship.request(users(:laura), users(:genius))
      end
    end  
  end

end
