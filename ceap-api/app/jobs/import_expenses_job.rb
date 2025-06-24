# frozen_string_literal: true

# Job para processamento assíncrono de arquivos CSV.
class ImportExpensesJob < ApplicationJob
  queue_as :default

  def perform(csv_content, state_uf)
    Rails.logger.info '--------------------------------------------------'
    Rails.logger.info '-> Iniciando o CsvProcessorService...'

    service = CsvProcessorService.new(csv_content, state_uf)
    service.call
  end
end
