# spec/integration/tasks_spec.rb

require 'swagger_helper'

RSpec.describe 'api/v1/tasks', type: :request do

  path '/api/v1/tasks' do

    get('list tasks') do
      tags 'Tasks'
      produces 'application/json'
      response(200, 'successful') do
        run_test!
      end
    end

    post('create task') do
      tags 'Tasks'
      consumes 'application/json'
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string },
          description: { type: :string },
          due_date: { type: :string, format: :date },
          status: { type: :string }
        },
        required: ['title', 'description']
      }
      response(201, 'successful') do
        let(:task) { { title: 'New Task', description: 'Task description', due_date: '2024-07-26', status: 'pending' } }
        run_test!
      end
    end
  end

  path '/api/v1/tasks/{id}' do
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show task') do
      tags 'Tasks'
      produces 'application/json'
      response(200, 'successful') do
        let(:id) { '1' }
        run_test!
      end
    end

    patch('update task') do
      tags 'Tasks'
      consumes 'application/json'
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string }
        },
        required: ['title']
      }
      response(200, 'successful') do
        let(:id) { '1' }
        let(:task) { { title: 'Updated Task' } }
        run_test!
      end
    end

    delete('delete task') do
      tags 'Tasks'
      response(204, 'successful') do
        let(:id) { '1' }
        run_test!
      end
    end
  end
end
