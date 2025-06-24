class ImportExpensesJob < ApplicationJob
  queue_as :default

  def perform(csv_content, state_uf)
    Rails.logger.info "--------------------------------------------------"
    Rails.logger.info "-> Iniciando o CsvProcessorService..."
    Rails.logger.info "--------------------------------------------------"

    service = CsvProcessorService.new(csv_content, state_uf)
    service.call
  end
end
