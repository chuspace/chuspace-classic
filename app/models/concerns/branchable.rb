# frozen_string_literal: true

module Branchable
  extend ActiveSupport::Concern

  included { DEFAULT_BRANCH = 'master' }

  def create_branch(ref, start_point = Git::Repository::START_REF)
    branch = rugged.branches.create(ref, start_point)
    Git::Branch.new(self, branch.name, branch.target)
  rescue Rugged::ReferenceError => e
    raise InvalidRef.new("Git::Branch #{ref} already exists") if e.to_s =~ %r{'refs\/heads\/#{ref}'}
    raise InvalidRef.new("Invalid reference #{start_point}")
  end

  def delete_branch(branch_name)
    rugged.branches.delete(branch_name)
  end

  def branch_exists?(name)
    rugged.branches.exists?(name)
  rescue Rugged::ReferenceError
    false
  end

  def find_branch(name, force_reload = false)
    reload if force_reload

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
