# frozen_string_literal: true

# Modelo para representar um deputado:
# Apresenta métodos para obter informações sobre o deputado e suas despesas.
class Deputy < ApplicationRecord
  BRAZILIAN_STATES = %w[AC AL AP AM BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ RN RS RO RR SC SE SP TO].freeze

  has_many :expenses, dependent: :destroy

  validates :name, presence: true
  validates :registration_id, presence: true, uniqueness: true
  validates :state, presence: true, inclusion: { in: BRAZILIAN_STATES }
  validates :party, presence: true

  scope :by_state, ->(state) { where(state: state) }
  scope :with_expenses, -> { joins(:expenses) }

  def total_expenses
    expenses.sum(:net_value)
  end

  def highest_expense
    expenses.order(net_value: :desc).first
  end

  def photo_url
    "http://www.camara.leg.br/internet/deputado/bandep/#{registration_id}.jpg"
  end
end
