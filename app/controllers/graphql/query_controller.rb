# frozen_string_literal: true

class Graphql::QueryController < Graphql::BaseController
  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    result = ApplicationSchema.execute(query, context: context, variables: variables)
    render json: result
  rescue => e
    raise e unless Rails.env.development?
    handle_error_in_development e
  end

  def editor
    render 'graphql/editor/index', layout: 'editor'
  end

  def schema
    render plain: GraphQL::Schema::Printer.new(ApplicationSchema).print_schema
  end

  private
    def context
      {
        file: uploaded_file,
        request: request,
        cookies: cookies,
        pundit: self
      }.freeze
    end

    def uploaded_file
      return unless params[:file]&.is_a?(ActionDispatch::Http::UploadedFile)
      params[:file]
    end
end
