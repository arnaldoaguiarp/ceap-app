require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'API V1 - Uploads', type: :request do
  # Incluído o helper do ActiveJob para testar se o job foi enfileirado
  include ActiveJob::TestHelper

  path '/api/v1/uploads' do
    post('Envia um arquivo CSV para processamento') do
      tags 'Uploads'
      # Conteúdo é multipart/form-data para envio de arquivos
      consumes 'multipart/form-data'
      produces 'application/json'

      parameter name: :file, in: :formData, type: :file, required: true, description: 'Arquivo CSV com as despesas.'
      parameter name: :state_uf, in: :formData, type: :string, required: true, description: 'Sigla do estado (UF) a ser processado.', example: 'CE'

      response(202, 'aceito') do
        schema type: :object,
               properties: {
                 message: { type: :string, example: 'Arquivo recebido. O processamento foi iniciado em segundo plano.' }
               }

        let(:state_uf) { 'CE' }
        let(:file) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'test_expenses.csv'), 'text/csv') }

        run_test! do |response|
          # Verifica se o job foi corretamente enfileirado pelo controller
          expect(ImportExpensesJob).to have_been_enqueued
        end
      end

      response(400, 'parâmetros faltando') do
        let(:state_uf) { 'CE' }
        let(:file) { nil }
        run_test!
      end
    end
  end
end
