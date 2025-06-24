require 'rails_helper'

RSpec.describe ImportExpensesJob, type: :job do
  include ActiveJob::TestHelper

  let(:csv_content) { "header1;header2\nvalue1;value2" }
  let(:state) { 'CE' }

  it 'enfileira o job corretamente' do
    # Verifica se o job pode ser adicionado à fila
    expect {
      described_class.perform_later(csv_content, state)
    }.to have_enqueued_job
  end

  it 'chama o CsvProcessorService com os argumentos corretos' do
    # Criação de um "dublê" do serviço
    mock_service = instance_double(CsvProcessorService)
    # Esperamos que o serviço seja instanciado com os argumentos certos
    allow(CsvProcessorService).to receive(:new).with(csv_content, state).and_return(mock_service)
    # E que o método `call` seja chamado no serviço instanciado
    expect(mock_service).to receive(:call)

    # Executa o job
    perform_enqueued_jobs { described_class.perform_later(csv_content, state) }
  end
end