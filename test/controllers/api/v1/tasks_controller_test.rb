require 'test_helper'

module Api
  module V1
    class TasksControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = users(:one)
        @task = tasks(:one)
        @headers = { 'Authorization': "Bearer #{generate_token_for(@user)}" }
      end

      test "should get index" do
        get api_v1_tasks_url, headers: @headers, as: :json
        assert_response :success
      end

      test "should show task" do
        get api_v1_task_url(@task), headers: @headers, as: :json
        assert_response :success
      end

      test "should create task" do
        assert_difference('Task.count') do
          post api_v1_tasks_url, params: { task: { title: 'New Task', description: 'Task description', due_date: '2024-07-26', status: 'pending' } }, headers: @headers, as: :json
        end
        assert_response :created
      end

      test "should update task" do
        patch api_v1_task_url(@task), params: { task: { title: 'Updated Task' } }, headers: @headers, as: :json
        @task.reload
        assert_equal 'Updated Task', @task.title
        assert_response :success
      end

      test "should destroy task" do
        assert_difference('Task.count', -1) do
          delete api_v1_task_url(@task), headers: @headers, as: :json
        end
        assert_response :ok
      end

      private

      def generate_token_for(user)
        Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      end
    end
  end
end
