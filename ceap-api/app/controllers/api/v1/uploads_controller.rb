# frozen_string_literal: true

module Api
  module V1
    # Controller que gerencia requisições relacionadas aos arquivos de importação.
    class UploadsController < ApplicationController
      # rubocop:disable Metrics/MethodLength
      def create
        file = params[:file]
        state_uf = params[:state_uf]

        if file.blank? || state_uf.blank?
          render json: { error: 'Arquivo e estado (state_uf) são obrigatórios' }, status: :bad_request
          return
        end

        # Lê todo o conteúdo do arquivo para uma string.
        csv_content = file.read

        Rails.logger.info '--------------------------------------------------'
        Rails.logger.info '-> Tentando enfileirar o ImportExpensesJob...'
        Rails.logger.info '--------------------------------------------------'

        # Enfileira o Job para processamento assíncrono
        ImportExpensesJob.perform_later(csv_content, state_uf)

        render json: { message: 'Arquivo recebido. O processamento foi iniciado em segundo plano.' }, status: :accepted
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
