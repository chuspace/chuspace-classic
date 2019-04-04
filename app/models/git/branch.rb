# frozen_string_literal: true

module Git
  class Branch
    include EncodingHelper
    attr_reader :name, :target,  :dereferenced_target

    def self.extract_branch_name(str)
      str.gsub(/\Arefs\/heads\//, '')
    end

    def self.dereference_object(object)
      object = object.target while object.is_a?(Rugged::Tag::Annotation)
      object
    end

    def initialize(repository, name, target)
      encode! name
      @name = name.gsub(/\Arefs\/(tags|heads)\//, '')
      @dereferenced_target = repository.find_commit(target)
      @target = if target.respond_to?(:oid)
        target.oid
      elsif target.respond_to?(:name)
        target.name
      elsif target.is_a? String
        target
      else
        nil
      end
    end
  end
end
