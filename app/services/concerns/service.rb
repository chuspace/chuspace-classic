module Service
  extend ActiveSupport::Concern

  included do
    def call
      raise NotImplementedError, "Must implement `.call' to run a service"
    end
  end

  class_methods do
    def call(**args)
      new(**args).call
    end
  end
end
