class Expense < ApplicationRecord
  belongs_to :deputy

  validates :deputy, presence: true
  validates :issue_date, presence: true
  validates :supplier, presence: true
  validates :net_value, presence: true, numericality: true
  validates :document_url, format: { with: URI.regexp(['http', 'https']) }, allow_blank: true

  scope :by_date_range, ->(start_date, end_date) { where(issue_date: start_date..end_date) }
  scope :by_supplier, ->(supplier) { where(supplier: supplier) }
  scope :ordered_by_value, -> { order(net_value: :desc) }
end
