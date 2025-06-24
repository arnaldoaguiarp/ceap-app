# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportExpensesJob, type: :job do
  include ActiveJob::TestHelper

  let(:csv_content) { "header1;header2\nvalue1;value2" }
  let(:state) { 'CE' }

  it 'queue the job correctly' do
    # Verifica se o job pode ser adicionado à fila
    expect do
      described_class.perform_later(csv_content, state)
    end.to have_enqueued_job
  end

  it 'calls CsvProcessorService with the correct arguments' do
    # Criação de um "dublê" do serviço
    service_spy = instance_spy(CsvProcessorService)
    allow(CsvProcessorService).to receive(:new).with(csv_content, state).and_return(service_spy)

    # Execução do job
    perform_enqueued_jobs { described_class.perform_later(csv_content, state) }

    # Verificação se o método foi chamado no dublê
    expect(service_spy).to have_received(:call)
  end
end
