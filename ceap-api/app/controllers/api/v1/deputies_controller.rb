# frozen_string_literal: true

module Api
  module V1
    # Controller que gerencia requisições relacionadas aos deputados.
    class DeputiesController < ApplicationController
      # GET /api/v1/deputies?state=CE
      def index
        @deputies = Deputy.by_state(params[:state])
                           .left_joins(:expenses)
                           .select('deputies.*, SUM(expenses.net_value) as total_expenses_sum')
                           .group('deputies.id')
                           .order('total_expenses_sum DESC NULLS LAST')

        render json: DeputySerializer.new(@deputies).serializable_hash
      end

      # GET /api/v1/deputies/:id
      def show
        # `includes`: essencial para carregar as despesas e evitar N+1.
        @deputy = Deputy.includes(:expenses).find(params[:id])

        options = {
          include: [:expenses],
          params: { is_show_action: true }
        }

        # O serializer usará os métodos #total_expenses e incluirá as despesas.
        render json: DeputySerializer.new(@deputy, options).serializable_hash
      end
    end
  end
end
