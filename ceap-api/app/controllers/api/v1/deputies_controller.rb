class Api::V1::DeputiesController < ApplicationController
  # GET /api/v1/deputies?state=CE
  def index
    # Escopo `by_state` para filtrar
    @deputies = Deputy.by_state(params[:state])
                        .left_joins(:expenses)
                        .select('deputies.*, SUM(expenses.net_value) as total_expenses_sum')
                        .group('deputies.id')
                        .order('total_expenses_sum DESC NULLS LAST')

    deputies_json = @deputies.map do |deputy|
      deputy.as_json.merge(
        photo_url: deputy.photo_url, 
        total_expenses: deputy.total_expenses_sum || 0
      )
    end

    render json: deputies_json
  end

  # GET /api/v1/deputies/:id
  def show
    # `includes`: essencial para carregar as despesas e evitar N+1.
    @deputy = Deputy.includes(:expenses).find(params[:id])

    render json: {
      deputy: @deputy.as_json.merge(
        photo_url: @deputy.photo_url
      ),
      total_expenses: @deputy.total_expenses,
      highest_expense: @deputy.highest_expense,
      expenses: @deputy.expenses.ordered_by_value
    }
  end
end
