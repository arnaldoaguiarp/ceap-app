require 'swagger_helper'

RSpec.describe 'API V1 - Deputados', type: :request do
  path '/api/v1/deputies' do
    get('Lista deputados de um estado com gastos') do
      tags 'Deputados'
      produces 'application/json'
      parameter name: :state, in: :query, type: :string, required: true, example: 'CE'

      response(200, 'sucesso') do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   # As propriedades do deputado já estão no schema global,
                   # abaixo a definição apenas do específico da resposta.
                   id: { type: :integer },
                   name: { type: :string },
                   registration_id: { type: :string },
                   state: { type: :string },
                   party: { type: :string },
                   photo_url: { type: :string, format: :uri },
                   total_expenses: { type: :number, format: :float, example: 1234.56 }
                 }
               }

        let!(:deputy) { create(:deputy, state: 'CE') }
        let(:state) { 'CE' }
        run_test!
      end
    end
  end

  path '/api/v1/deputies/{id}' do
    get('Detalha um deputado e suas despesas') do
      tags 'Deputados'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, required: true

      response(200, 'sucesso') do
        # `$ref` referencia os schemas definidos no swagger_helper
        schema type: :object,
               properties: {
                 deputy: { '$ref' => '#/components/schemas/Deputy' },
                 total_expenses: { type: :string, format: :decimal, example: '25461.83' },
                 highest_expense: { '$ref' => '#/components/schemas/Expense' },
                 expenses: {
                   type: :array,
                   items: { '$ref' => '#/components/schemas/Expense' }
                 }
               }

        let!(:deputy_with_expenses) { create(:deputy, :with_expenses) }
        let(:id) { deputy_with_expenses.id }
        run_test!
      end

      response(404, 'não encontrado') do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
