# frozen_string_literal: true

class Graphql::QueryController < Graphql::BaseController
  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    result = ApplicationSchema.execute(query, variables: variables)
    render json: result
  rescue => e
    raise e unless Rails.env.development?
    handle_error_in_development e
  end

  def editor
    render 'graphql/editor/index', layout: 'editor'
  end
end
