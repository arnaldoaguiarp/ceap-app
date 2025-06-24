# frozen_string_literal: true

# spec/swagger_helper.rb
require 'rails_helper'

RSpec.configure do |config|
  config.swagger_root = Rails.root.join('swagger').to_s

  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API Ranking de Gastos de Deputados',
        version: 'v1',
        description: 'API para o Desafio Backend da Agenda Edu.'
      },
      paths: {},
      servers: [
        {
          url: 'http://localhost:3000',
          description: 'Servidor de Desenvolvimento Local'
        }
      ],
      # Definição central dos schemas reutilizáveis
      components: {
        schemas: {

          Deputy: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1 },
              name: { type: :string, example: 'Deputado Teste' },
              registration_id: { type: :string, example: '123456' },
              state: { type: :string, example: 'CE' },
              party: { type: :string, example: 'TESTE' },
              photo_url: { type: :string, format: :uri, example: 'http://camara.leg.br/...' }
            },
            required: %w[id name registration_id state party photo_url]
          },

          Expense: {
            type: :object,
            properties: {
              id: { type: :integer, example: 101 },
              issue_date: { type: :string, format: :date, example: '2024-06-24' },
              supplier: { type: :string, example: 'Fornecedor XYZ' },
              net_value: { type: :string, format: :decimal, example: '199.99' },
              document_url: { type: :string, format: :uri, example: 'http://camara.leg.br/...' }
            },
            required: %w[id issue_date supplier net_value]
          }
        }
      }
    }
  }

  config.swagger_format = :yaml
end
