require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @unique_email = "unique_user_#{SecureRandom.hex(10)}@example.com"
    @user = User.create!(email: @unique_email, password: 'password')
    Rails.logger.debug "User creation errors: #{@user.errors.full_messages}" unless @user.persisted?
    Rails.logger.debug "User created: #{@user.inspect}"
    assert @user.persisted?, "User was not created successfully"
  end

  test "should create user" do
    assert_difference('User.count') do
      post user_registration_url, params: { user: { email: "another_user_#{SecureRandom.hex(10)}@example.com", password: 'password' } }, as: :json
    end

    assert_response :created
  end

  test "should not create user with invalid params" do
    post user_registration_url, params: { user: { email: 'invalid_user@example.com' } }, as: :json
    assert_response :unprocessable_entity
  end

  test "should login user with valid credentials" do
    post user_session_url, params: { user: { email: @user.email, password: 'password' } }, as: :json
    Rails.logger.debug "Response body: #{@response.body}"
    assert_response :success
    assert_not_nil @response.parsed_body['token']
  end

  test "should not login user with invalid credentials" do
    post user_session_url, params: { user: { email: @user.email, password: 'wrong_password' } }, as: :json
    Rails.logger.debug "Response body: #{@response.body}"
    assert_response :unauthorized
  end

  test "should logout user" do
    post user_session_url, params: { user: { email: @user.email, password: 'password' } }, as: :json
    @token = @response.parsed_body['token']
    Rails.logger.debug "Login token: #{@token}"

    delete destroy_user_session_url, headers: { 'Authorization': "Bearer #{@token}" }, as: :json
    assert_response :success
  end
end
