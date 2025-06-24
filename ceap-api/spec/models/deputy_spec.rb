# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Deputy, type: :model do
  # Criar uma instância do modelo para os testes
  subject(:deputy) { build(:deputy) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:registration_id) }
    it { is_expected.to validate_uniqueness_of(:registration_id).case_insensitive }
    it { is_expected.to validate_presence_of(:state) }
    it { is_expected.to validate_presence_of(:party) }
  end

  describe 'association' do
    it { is_expected.to have_many(:expenses).dependent(:destroy) }
  end

  describe 'scopes' do
    # Escopo `.by_state` funciona como esperado
    describe '.by_state' do
      let!(:deputy_in_ce) { create(:deputy, state: 'CE') }
      let!(:deputy_in_sp) { create(:deputy, state: 'SP') }

      it 'includes deputies from the specified state' do
        result = described_class.by_state('CE')
        expect(result).to include(deputy_in_ce)
      end

      it 'excludes deputies from other states' do
        result = described_class.by_state('CE')
        expect(result).not_to include(deputy_in_sp)
      end
    end
  end

  describe 'instance methods' do
    # Testa a lógica dos métodos do modelo
    describe '#total_expenses' do
      it 'returns the correct sum of the net values of the expenses' do
        deputy = create(:deputy)
        create(:expense, deputy: deputy, net_value: 100.00)
        create(:expense, deputy: deputy, net_value: 50.50)
        create(:expense, deputy: deputy, net_value: 200.00)

        expect(deputy.total_expenses).to eq(350.50)
      end
    end

    describe '#photo_url' do
      it 'returns the correct URL of the photo based on the registration_id' do
        deputy = build(:deputy, registration_id: 98_765)
        expected_url = 'http://www.camara.leg.br/internet/deputado/bandep/98765.jpg'

        expect(deputy.photo_url).to eq(expected_url)
      end
    end
  end
end
