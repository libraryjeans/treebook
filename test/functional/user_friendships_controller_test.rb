require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase
  context "#new" do 
  	context "when not logged in" do
  		should "redirect to the login page" do
  			get :new
  			assert_response :redirect
  		end
  	end

  	context "when logged in" do
  		setup do
  			sign_in users(:laura)
  		end

  		should "get new and return success" do
  			get :new
  			assert_response :success
  		end

  		should "should set a flash error if the friend_id params is missing" do
  			get :new, {}
  			assert_equal "Friend required", flash[:error]
  		end

  		should "display friend's name" do
  			get :new, friend_id: users(:daffy)
  			assert_match /#{users(:daffy).full_name}/, response.body
  		end

      should "assign a new user friendship" do
        get :new, friend_id: users(:daffy)
        assert assigns(:user_friendship)
      end	

  		should "assign a new user friendship to the correct friend" do
  			get :new, friend_id: users(:daffy)
  			assert_equal users(:daffy), assigns(:user_friendship).friend
  		end	

  		should "assign a new user friendship to the currently logged in user" do
  			get :new, friend_id: users(:daffy)
  			assert_equal users(:laura), assigns(:user_friendship).user 
  		end

  		should "returns a 404 status if no friend found" do
  			get :new, friend_id: 'invalid'
  			assert_response :not_found
  		end

  		should "ask for confirmation to request friendship" do
  			get :new, friend_id: users(:daffy)
  			assert_match /Do you really want to friend #{users(:daffy).full_name}?/, response.body
  		end
  	end
  end
end
