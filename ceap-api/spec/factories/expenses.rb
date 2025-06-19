FactoryBot.define do
  factory :expense do
    deputy { nil }
    issue_date { "2025-06-18" }
    supplier { "MyString" }
    net_value { "9.99" }
    document_url { "MyString" }
    expense_type { "MyString" }
  end
end
