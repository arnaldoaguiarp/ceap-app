# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvProcessorService, type: :service do
  let(:valid_csv_content) do
    <<~CSV
      txNomeParlamentar;ideCadastro;sgUF;sgPartido;datEmissao;txtFornecedor;vlrLiquido;urlDocumento
      Deputado A;111;CE;P-A;2024-01-15;Fornecedor 1;100.50;http://a.com
      Deputado B;222;SP;P-B;2024-01-16;Fornecedor 2;200.00;http://b.com
      Deputado C;333;CE;P-C;2024-01-17;Fornecedor 3;300.75;http://c.com
    CSV
  end

  let(:csv_with_invalid_rows) do
    <<~CSV
      txNomeParlamentar;ideCadastro;sgUF;sgPartido;datEmissao;txtFornecedor;vlrLiquido;urlDocumento
      ;111;CE;P-A;2024-01-15;Fornecedor 1;100.50;http://a.com
      Deputado B;222;NA;P-B;2024-01-16;Fornecedor 2;200.00;http://b.com
      Deputado C;333;CE;P-C;;Fornecedor 3;300.75;http://c.com
    CSV
  end

  describe '#call' do
    subject(:service_call) { described_class.new(csv_content, state).call }

    context 'with valid data for CE state' do
      let(:csv_content) { valid_csv_content }
      let(:state) { 'CE' }

      it 'create 2 new deputies and 2 new expenses' do
        service = described_class.new(csv_content, state)

        expect { service.call }.to change(Deputy, :count).by(2)
                               .and change(Expense, :count).by(2)
      end

      it 'sets up old data' do
        deputy_antigo = create(:deputy, state: 'CE', name: 'Deputado Antigo')
        expect(Deputy.find_by(name: 'Deputado Antigo')).to eq(deputy_antigo)
      end

      it 'sets up old data in another state' do
        deputy_outro_estado = create(:deputy, state: 'SP', name: 'Deputado Outro Estado')
        expect(Deputy.find_by(name: 'Deputado Outro Estado')).to eq(deputy_outro_estado)
      end

      it 'cleans old data before processing' do
        service = described_class.new(csv_content, state)
        service.call

        expect(Deputy.find_by(name: 'Deputado Antigo')).to be_nil
      end

      it 'clean deputy from another state' do
        service = described_class.new(csv_content, state)
        service.call

        expect(Deputy.find_by(name: 'Deputado Outro Estado')).to be_nil
      end

      it 'creates new deputies' do
        service = described_class.new(csv_content, state)
        service.call

        expect(Deputy.where(state: 'CE').count).to eq(2)
      end
    end

    context 'with invalid data' do
      it 'ignores lines that do not belong to the state' do
        service = described_class.new(valid_csv_content, 'SP')

        expect { service.call }.to change(Deputy, :count).from(0).to(1)
                               .and change(Expense, :count).from(0).to(1)
      end

      it 'ignores lines with missing essential data and does not create new deputies' do
        service = described_class.new(csv_with_invalid_rows, 'CE')
        expect { service.call }.not_to change(Deputy, :count)
      end

      it 'ignores lines with missing essential data and does not create new expenses' do
        service = described_class.new(csv_with_invalid_rows, 'CE')
        expect { service.call }.not_to change(Expense, :count)
      end
    end
  end
end
