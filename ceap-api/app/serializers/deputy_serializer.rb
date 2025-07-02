# frozen_string_literal: true

# Serializer do modelo Deputy, formatando os dados para JSON.
class DeputySerializer
  include JSONAPI::Serializer

  # Atributos do modelo
  attributes :id, :name, :registration_id, :state, :party

  # Atributo customizado que usa um método do modelo
  attribute :photo_url do |deputy|
    deputy.photo_url
  end

  # Atributo que pode vir tanto do cálculo SQL (no index)
  # quanto do método do modelo (no show)
  attribute :total_expenses do |deputy, params|
    # Se o parâmetro `is_show_action` for verdadeiro, usamos o método do modelo.
    if params[:is_show_action]
      format('%.2f', deputy.total_expenses)
    else
      # Valor pré-calculado pela query do index.
      format('%.2f', deputy.total_expenses_sum || 0)
    end
  end

  has_many :expenses, serializer: ExpenseSerializer
end
