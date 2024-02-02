require "test_helper"

class UsersProfileTest < ActionDispatch::IntegrationTest
	include ApplicationHelper
	include Pagy::Backend

  def setup
    @user = users(:michael)
  end

  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'nav.pagy-bootstrap-nav'
    _pagy, microposts = pagy(@user.microposts.all, page: 1)
		microposts.each do |micropost|
      assert_match micropost.content, response.body
    end
  end
end
