class Deputy < ApplicationRecord
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
