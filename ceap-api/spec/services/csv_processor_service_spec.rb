# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvProcessorService, type: :service do
  let(:valid_csv_content) do
    <<~CSV
      txNomeParlamentar;ideCadastro;sgUF;sgPartido;datEmissao;txtFornecedor;vlrLiquido;urlDocumento
      Deputado A;111;CE;P-A;2024-01-15;Fornecedor 1;100.50;[http://a.com](http://a.com)
      Deputado B;222;SP;P-B;2024-01-16;Fornecedor 2;200.00;[http://b.com](http://b.com)
      Deputado C;333;CE;P-C;2024-01-17;Fornecedor 3;300.75;[http://c.com](http://c.com)
    CSV
  end

  let(:csv_with_invalid_rows) do
    <<~CSV
      txNomeParlamentar;ideCadastro;sgUF;sgPartido;datEmissao;txtFornecedor;vlrLiquido;urlDocumento
      ;111;CE;P-A;2024-01-15;Fornecedor 1;100.50;[http://a.com](http://a.com)
      Deputado B;222;NA;P-B;2024-01-16;Fornecedor 2;200.00;[http://b.com](http://b.com)
      Deputado C;333;CE;P-C;;Fornecedor 3;300.75;[http://c.com](http://c.com)
    CSV
  end

  describe '#call' do
    context 'with valid data for the correct state' do
      it 'creates Deputies and Expenses correctly' do
        service = described_class.new(valid_csv_content, 'CE')

        # Verifica se o número de Deputados e Despesas muda como esperado
        expect { service.call }.to change(Deputy, :count).by(2)
                               .and change(Expense, :count).by(2)
      end

      it 'creates a new deputy' do
        create(:deputy, state: 'CE', name: 'Deputado Antigo')
        service = described_class.new(valid_csv_content, 'CE')
        service.call
        expect(Deputy.where(state: 'CE').count).to eq(2)
      end

      it 'removes the old deputy' do
        create(:deputy, state: 'CE', name: 'Deputado Antigo')
        service = described_class.new(valid_csv_content, 'CE')
        service.call
        expect(Deputy.find_by(name: 'Deputado Antigo')).to be_nil
      end

      it 'creates the correct number of new deputies' do
        service = described_class.new(valid_csv_content, 'CE')
        service.call

        expect(Deputy.where(state: 'CE').count).to eq(2)
      end
    end

    context 'with invalid data' do
      it 'ignores lines that do not belong to the state' do
        service = described_class.new(valid_csv_content, 'SP')
        # Espera que apenas o Deputado B (de SP) e sua despesa sejam criados
        expect { service.call }.to change(Deputy, :count).by(1)
                               .and change(Expense, :count).by(1)
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
