require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

	# def setup
  #   @user = users(:michael) # users соотв. названия файла фикстур, символ :michael находит пользователя с соотв. ключом
  # end

	test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

	# test "login with valid information" do
  #   get login_path
  #   post login_path, params: { session: { email: "test@example.com", password: "password1234" } }
	# 	assert_redirected_to @user
  #   follow_redirect!
  #   assert_template 'users/show'
  #   assert_select "a[href=?]", login_path, count: 0 # проверяет отстутствие ссылки
  #   assert_select "a[href=?]", logout_path
  #   assert_select "a[href=?]", user_path(@user)
  # end
end
