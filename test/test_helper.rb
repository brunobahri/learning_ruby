ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require 'database_cleaner/active_record'
require 'securerandom'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Configuração do DatabaseCleaner
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)

    # Limpa o banco de dados antes de todos os testes
    setup do
      DatabaseCleaner.start
    end

    # Limpa o banco de dados após cada teste
    teardown do
      DatabaseCleaner.clean
    end
  end
end
