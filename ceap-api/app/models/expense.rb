class Expense < ApplicationRecord
  belongs_to :deputy
  
  validates :deputy, presence: true
  validates :issue_date, presence: true
  validates :supplier, presence: true
  validates :net_value, presence: true, numericality: { greater_than: 0 }
  validates :document_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp }
  
  scope :by_date_range, ->(start_date, end_date) { where(issue_date: start_date..end_date) }
  scope :by_supplier, ->(supplier) { where(supplier: supplier) }
  scope :ordered_by_value, -> { order(net_value: :desc) }
end
