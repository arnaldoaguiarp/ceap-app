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
    context 'com dados válidos e para o estado correto' do
      it 'cria os Deputados e as Despesas corretamente' do
        service = described_class.new(valid_csv_content, 'CE')

        # Verifica se o número de Deputados e Despesas muda como esperado
        expect { service.call }.to change(Deputy, :count).by(2)
                               .and change(Expense, :count).by(2)
      end

      it 'limpa os dados antigos do mesmo estado antes de importar' do
        # Cria um deputado antigo no estado 'CE'
        create(:deputy, state: 'CE', name: 'Deputado Antigo')
        expect(Deputy.where(state: 'CE').count).to eq(1)

        service = described_class.new(valid_csv_content, 'CE')
        service.call

        # Verifica se o deputado antigo foi removido e os novos criados
        expect(Deputy.find_by(name: 'Deputado Antigo')).to be_nil
        expect(Deputy.where(state: 'CE').count).to eq(2)
      end
    end

    context 'com dados inválidos' do
      it 'ignora linhas que não pertencem ao estado' do
        service = described_class.new(valid_csv_content, 'SP')
        # Espera que apenas o Deputado B (de SP) e sua despesa sejam criados
        expect { service.call }.to change(Deputy, :count).by(1)
                               .and change(Expense, :count).by(1)
      end

      it 'ignora linhas com dados essenciais faltando' do
        service = described_class.new(csv_with_invalid_rows, 'CE')
        # no CSV de exemplo têm problemas (nome/data faltando).
        expect { service.call }.to change(Deputy, :count).by(0)
                               .and change(Expense, :count).by(0)
      end
    end
  end
end