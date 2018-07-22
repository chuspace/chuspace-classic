# frozen_string_literal: true

module SentryContext
  extends ActiveSupport::Concern

  included do
    private def set_raven_context
      Raven.user_context(id: Current.user&.id)
      Raven.extra_context(params: params.to_unsafe_h, url: request.url)
    end
  end
end
