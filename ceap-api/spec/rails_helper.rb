# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'

# Carrega todos os arquivos .rb dentro de spec/support/
Rails.root.glob('spec/support/**/*.rb').each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.before(:suite) do
    DatabaseCleaner.allow_remote_database_url = true
    # Limpa o banco de dados completamente UMA VEZ antes de TODOS os testes rodarem.
    DatabaseCleaner.clean_with(:truncation)
    # Define a estratégia padrão para os testes como 'transaction', que é a mais rápida.
    DatabaseCleaner.strategy = :transaction
  end

  config.around do |example|
    # Para cada teste ('it'), executa a limpeza.
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
