# frozen_string_literal: true

class Graphql::QueryController < Graphql::BaseController
  include GraphqlQueryCache

  before_action :verify!, except: :schema
  before_action :authenticate!, except: :schema, unless: :unauthenticated?

  def execute
    variables = ensure_hash(params[:variables])
    document  = graphql_document(params[:query])
    result    = ChuspaceSchema.execute(document: document, variables: variables, context: context_hash)

    if result['errors']
      render json: { errors: result['errors'] }, status: :unprocessable_entity
      return
    end

    render json: result
  end

  def schema
    render plain: GraphQL::Schema::Printer.new(ChuspaceSchema).print_schema
  end

  private
    def unauthenticated?
      operations.include?(operation)
    end

    def context_hash
      {
        file: uploaded_file,
        pundit: self
      }
    end

    def ensure_hash(variables)
      case variables
      when String
        return {} unless variables.present?
        ensure_hash(JSON.parse(variables))
      when Hash, ActionController::Parameters
        variables
      when nil
        {}
      else
        fail Schema::Errors::QueryArgumentError, "Unexpected parameter: #{variables}"
      end
    end

    def operation
      params[:operationName]
    end

    def operations
      %w[
        graphiql
        IntrospectionQuery
        loginMutation
        magicLoginMutation
        signupMutation
      ]
    end

    def verify!
      fail Schema::Errors::QueryExecutionError, 'Invalid operation type' unless operation.is_a?(String)
    end

    def uploaded_file
      return unless params[:file]&.is_a?(ActionDispatch::Http::UploadedFile)
      params[:file]
    end
end
