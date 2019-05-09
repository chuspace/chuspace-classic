# frozen_string_literal: true

module Git
  class Branch
    include EncodingHelper
    attr_reader :name, :target, :dereferenced_target, :rugged
    DEFAULT_BRANCH = 'master'

    def self.extract_branch_name(str)
      str.gsub(%r{\Arefs\/heads\/}, '')
    end

    def self.dereference_object(object)
      object = object.target while object.is_a?(Rugged::Tag::Annotation)
      object
    end

    def initialize(repository, name, target)
      encode! name
      @name = name.gsub(%r{\Arefs\/(tags|heads)\/}, '')
      @dereferenced_target = repository.find_commit(target)
      @rugged = repository.rugged
      @target =
        if target.respond_to?(:oid)
          target.oid
        elsif target.respond_to?(:name)
          target.name
        elsif target.is_a? String
          target
        else
          nil
        end
    end

    def create(start_point: Git::Repository::START_REF)
      branch = rugged.branches.create(name, start_point)
      Git::Branch.new(self, branch.name, branch.target)
    rescue Rugged::ReferenceError => e
      raise InvalidRef.new("Git::Branch #{name} already exists") if e.to_s =~ %r{'refs\/heads\/#{name}'}
      raise InvalidRef.new("Invalid reference #{start_point}")
    end

    def delete
      rugged.branches.delete(name)
    end

    def exists?
      rugged.branches.exists?(name)
    rescue Rugged::ReferenceError
      false
    end

    def find(name)
      branch = rugged.branches[name]
      Git::Branch.new(self, branch.name, branch.target) if branch
    end

    def local_branches
      rugged.branches.each(:local).map { |branch| Git::Branch.new(self, branch.name, branch.target) }
    end

    def branch_count
      rugged.branches.count do |branch|
        begin
          branch.name && branch.target

          true
        rescue Rugged::ReferenceError
          false
        end
      end
    end

    def branch_names
      branches.map(&:name)
    end

    def branches
      rugged.branches.map do |branch|
        begin
          Git::Branch.new(self, branch.name, branch.target)
        rescue Rugged::ReferenceError

        end
      end.compact
        .sort_by(&:name)
    end
  end
end
