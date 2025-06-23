class Api::V1::UploadsController < ApplicationController
  def create
    file = params[:file]
    state_uf = params[:state_uf]

    if file.nil? || state_uf.blank?
      render json: { error: 'Arquivo e estado (state_uf) são obrigatórios' }, status: :bad_request
      return
    end

    # Salva o arquivo temporariamente para o Job poder acessá-lo
    temp_path = Rails.root.join('tmp', file.original_filename)
    File.open(temp_path, 'wb') { |f| f.write(file.read) }

    temp_path = Rails.root.join('tmp', file.original_filename)
    File.open(temp_path, 'wb') { |f| f.write(file.read) }

    Rails.logger.info "--------------------------------------------------"
    Rails.logger.info "-> Upload Controller: Arquivo salvo em #{temp_path}."
    Rails.logger.info "-> Tentando enfileirar o ImportExpensesJob..."
    Rails.logger.info "--------------------------------------------------"

    # Enfileira o Job para processamento assíncrono
    ImportExpensesJob.perform_later(temp_path.to_s, state_uf)

    render json: { message: 'Arquivo recebido. O processamento foi iniciado em segundo plano.' }, status: :accepted
  end
end
