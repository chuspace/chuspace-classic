# frozen_string_literal: true

module Loaders
  class AssociationLoader < GraphQL::Batch::Loader
    attr_reader :klass, :association

    def initialize(klass, association)
      fail ArgumentError, "association to load must be a symbol (got #{association.inspect})" unless association.is_a?(Symbol)
      fail ArgumentError, "cannot load associations for class #{klass.name}" unless klass < ActiveRecord::Base
      fail TypeError, "association #{association} does not exist on #{klass.name}" unless klass.reflect_on_association(association)

      @klass = klass
      @association = association
    end

    def load(model)
      fail TypeError, "loader for #{klass.name} can't load associations for objects of type #{model.class.name}" unless model.is_a?(klass)
      model.association(@association).loaded? ? Promise.resolve(model) : super
    end

    def perform(models)
      ActiveRecord::Associations::Preloader.new.preload(models, association)
      models.each { |m| fulfill(m, m) }
    end
  end
end
