require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @task = Task.new(title: 'Test Task', description: 'Test Description', due_date: '2024-07-26', status: 'pending', user: @user)
  end

  test "should be valid with valid attributes" do
    assert @task.valid?
  end

  test "should not be valid without a title" do
    @task.title = nil
    assert_not @task.valid?
  end

  test "should not be valid without a description" do
    @task.description = nil
    assert_not @task.valid?
  end

  test "should not be valid without a due date" do
    @task.due_date = nil
    assert_not @task.valid?
  end

  test "should not be valid without a status" do
    @task.status = nil
    assert_not @task.valid?
  end

  test "should not be valid without a user" do
    @task.user = nil
    assert_not @task.valid?
  end
end
