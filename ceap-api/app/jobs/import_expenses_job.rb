require_relative '../services/csv_processor_service'

class ImportExpensesJob < ApplicationJob
  queue_as :default

  def perform(file_path, state_uf)
    Rails.logger.info "--------------------------------------------------"
    Rails.logger.info "-> Iniciando o CsvProcessorService..."
    Rails.logger.info "--------------------------------------------------"

    service = CsvProcessorService.new(file_path, state_uf)
    service.call
  end
end
