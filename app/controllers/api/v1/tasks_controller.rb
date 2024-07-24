module Api
  module V1
    class TasksController < ApplicationController
      before_action :authenticate_user!
      skip_before_action :verify_authenticity_token
      before_action :set_task, only: [:show, :update, :destroy]

      # GET /tasks
      def index
        @tasks = current_user.tasks
        render json: @tasks
      end

      # GET /tasks/:id
      def show
        render json: @task
      end

      def create
        @task = current_user.tasks.build(task_params)
        if @task.save
          render json: @task, status: :created
        else
          render json: @task.errors, status: :unprocessable_entity
        end
      end

      # PUT /tasks/:id
      def update
        if @task.update(task_params)
          render json: @task
        else
          render json: @task.errors, status: :unprocessable_entity
        end
      end

      # DELETE /tasks/:id
      def destroy
        @task.destroy
        render json: { message: 'Task deleted successfully' }, status: :ok
      end

      private

      def set_task
        @task = current_user.tasks.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Task not found' }, status: :not_found
      end

      def task_params
        params.require(:task).permit(:title, :description, :due_date, :status)
      end
    end
  end
end
