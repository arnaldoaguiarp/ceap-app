FactoryBot.define do
  factory :deputy do
    name { Faker::Name.name }
    registration_id { Faker::Number.unique.number(digits: 6) }
    state { 'CE' }
    party { 'TESTE' }

    # "trait": conjunto de atributos que podemos adicionar opcionalmente.
    # Permite criar `create(:deputy_with_expenses)` nos testes.
    trait :with_expenses do
      after(:create) do |deputy, evaluator|
        create_list(:expense, 5, deputy: deputy)
      end
    end
  end
end