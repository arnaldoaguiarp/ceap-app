FactoryBot.define do
  factory :expense do
    association :deputy # Associa a uma factory de deputado automaticamente

    issue_date { Faker::Date.between(from: 1.year.ago, to: Date.current) }
    supplier { Faker::Company.name }
    net_value { Faker::Number.decimal(l_digits: 4, r_digits: 2) }
    document_url { Faker::Internet.url }
  end
end