# frozen_string_literal: true

# Classe base para todos os modelos do banco de dados.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
