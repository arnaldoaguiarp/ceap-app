# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'Api::V1::Deputies', type: :request do
  path '/api/v1/deputies' do
    get('Lista deputados de um estado com gastos') do
      tags 'Deputados'
      produces 'application/json'
      parameter name: :state, in: :query, type: :string, required: true, example: 'CE'

      response(200, 'sucesso') do
        schema type: :object,
               properties: {
                 # A chave principal é 'data'
                 data: {
                   type: :array,
                   items: {
                     # Cada item no array tem esta estrutura JSON:API
                     type: :object,
                     properties: {
                       id: { type: :string },
                       type: { type: :string, example: 'deputy' },
                       attributes: {
                         # Os atributos reais estão aninhados aqui
                         type: :object,
                         properties: {
                           id: { type: :integer },
                           name: { type: :string },
                           registration_id: { type: :string },
                           state: { type: :string },
                           party: { type: :string },
                           photo_url: { type: :string, format: :uri },
                           total_expenses: { type: :string, format: :decimal }
                         }
                       }
                     }
                   }
                 }
               }

        before do
          create(:deputy, state: 'CE')
        end

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
        schema type: :object,
               properties: {
                 data: { '$ref' => '#/components/schemas/Deputy' },
                 # O serializer coloca os dados relacionados em um array 'included'
                 included: {
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
