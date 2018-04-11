# frozen_string_literal: true

module Resolvers
  class ApplicationResolver
    attr_reader :params, :arguments, :record, :pundit, :context, :viewer

    def self.call(*args)
      new(*args).call
    end

    def initialize(obj, args, ctx)
      @record = obj
      @arguments = args
      @params = ActionController::Parameters.new(args.to_h)
      @pundit = ctx[:pundit]
      @context = ctx
      @viewer = Viewer::STATIC
    end

    private
      def error_message_for(field, message, options = {})
        { errors: [OpenStruct.new(field: field, messages: [message])], **options }
      end
  end
end
