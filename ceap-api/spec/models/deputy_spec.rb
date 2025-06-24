require 'rails_helper'

RSpec.describe Deputy, type: :model do
  # Criar uma instância do modelo para os testes
  subject(:deputy) { build(:deputy) }

  describe 'validações' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:registration_id) }
    it { is_expected.to validate_uniqueness_of(:registration_id).case_insensitive }
    it { is_expected.to validate_presence_of(:state) }
    it { is_expected.to validate_presence_of(:party) }
  end

  describe 'associação' do
    it { is_expected.to have_many(:expenses).dependent(:destroy) }
  end

  describe 'escopos (scopes)' do
    # Escopo `.by_state` funciona como esperado
    context '.by_state' do
      let!(:deputy_in_ce) { create(:deputy, state: 'CE') }
      let!(:deputy_in_sp) { create(:deputy, state: 'SP') }

      it 'retorna apenas os deputados do estado especificado' do
        result = Deputy.by_state('CE')

        expect(result).to include(deputy_in_ce)
        expect(result).not_to include(deputy_in_sp)
      end
    end
  end

  describe 'métodos de instância' do
    # Testa a lógica dos métodos do modelo
    context '#total_expenses' do
      it 'retorna a soma correta dos valores líquidos das despesas' do
        deputy = create(:deputy)
        create(:expense, deputy: deputy, net_value: 100.00)
        create(:expense, deputy: deputy, net_value: 50.50)
        create(:expense, deputy: deputy, net_value: 200.00)

        expect(deputy.total_expenses).to eq(350.50)
      end
    end

    context '#photo_url' do
      it 'retorna a URL correta da foto baseada no registration_id' do
        deputy = build(:deputy, registration_id: 98765)
        expected_url = "http://www.camara.leg.br/internet/deputado/bandep/98765.jpg"

        expect(deputy.photo_url).to eq(expected_url)
      end
    end
  end
end
