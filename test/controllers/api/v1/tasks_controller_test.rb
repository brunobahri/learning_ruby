require 'test_helper'

module Api
  module V1
    class TasksControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = users(:one)
        @other_user = users(:two)
        @task = tasks(:one)
        @task.user = @user
        @task.save
        @headers = { 'Authorization': "Bearer #{generate_token_for(@user)}" }

        # Certifique-se de limpar o cache antes de cada teste
        Rack::Attack.cache.store.clear
      end

      test "should get index" do
        get api_v1_tasks_url, headers: @headers, as: :json
        assert_response :success
      end

      test "should not get index if not authenticated" do
        get api_v1_tasks_url, as: :json
        assert_response :unauthorized
      end

      test "should show task" do
        get api_v1_task_url(@task), headers: @headers, as: :json
        assert_response :success
      end

      test "should not show task if not authenticated" do
        get api_v1_task_url(@task), as: :json
        assert_response :unauthorized
      end

      test "should create task" do
        assert_difference('Task.count') do
          post api_v1_tasks_url, params: { task: { title: 'New Task', description: 'Task description', due_date: '2024-07-26', status: 'pending' } }, headers: @headers, as: :json
        end
        assert_response :created
      end

      test "should not create task if not authenticated" do
        assert_no_difference('Task.count') do
          post api_v1_tasks_url, params: { task: { title: 'New Task', description: 'Task description', due_date: '2024-07-26', status: 'pending' } }, as: :json
        end
        assert_response :unauthorized
      end

      test "should update task" do
        patch api_v1_task_url(@task), params: { task: { title: 'Updated Task' } }, headers: @headers, as: :json
        @task.reload
        assert_equal 'Updated Task', @task.title
        assert_response :success
      end

      test "should not update task if not authenticated" do
        patch api_v1_task_url(@task), params: { task: { title: 'Updated Task' } }, as: :json
        assert_response :unauthorized
      end

      test "should destroy task" do
        assert_difference('Task.count', -1) do
          delete api_v1_task_url(@task), headers: @headers, as: :json
        end
        assert_response :ok
      end

      test "should not destroy task if not authenticated" do
        assert_no_difference('Task.count') do
          delete api_v1_task_url(@task), as: :json
        end
        assert_response :unauthorized
      end

      test "should not access other user's task" do
        other_task = tasks(:two)
        other_task.user = @other_user
        other_task.save

        get api_v1_task_url(other_task), headers: @headers, as: :json
        assert_response :not_found
      end

      test "should throttle requests" do
        Rack::Attack.cache.store.clear # Limpar cache para garantir estado limpo

        5.times do |i|
          get api_v1_tasks_url, headers: @headers, as: :json
          assert_response :success
        end

        get api_v1_tasks_url, headers: @headers, as: :json
        assert_response :too_many_requests
      end

      private

      def generate_token_for(user)
        Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
      end
    end
  end
end
