# frozen_string_literal: true

class ExpenseSerializer
  include JSONAPI::Serializer
  attributes :id, :issue_date, :supplier, :net_value, :document_url
end