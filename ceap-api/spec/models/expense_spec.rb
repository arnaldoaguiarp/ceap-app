require 'rails_helper'

RSpec.describe Expense, type: :model do
  subject(:expense) { build(:expense) }

  describe 'validações' do
    it { is_expected.to validate_presence_of(:issue_date) }
    it { is_expected.to validate_presence_of(:supplier) }
    it { is_expected.to validate_presence_of(:net_value) }
    it { is_expected.to validate_numericality_of(:net_value) }

    # Testa a validação flexível da URL
    context 'para document_url' do
      it { is_expected.to allow_value(nil, '').for(:document_url) }
      it { is_expected.to allow_value('http://example.com', 'https://sub.domain.org/path?q=1').for(:document_url) }
      it { is_expected.to_not allow_value('not-a-url', 'ftp://example.com', 'http//missing-slashes.com').for(:document_url).with_message('is invalid') }
    end
  end

  describe 'associações' do
    it { is_expected.to belong_to(:deputy) }
  end
end
