# frozen_string_literal: true

module Commitable
  extend ActiveSupport::Concern

  def has_commits?
    !empty?
  end

  def find_commit(commit_id = Git::Repository::START_REF)
    return Git::Commit.new(commit_id) if commit_id.is_a?(Rugged::Commit)

    obj = if commit_id.is_a?(String)
      repository.rev_parse_target(commit_id)
    else
      Git::Branch.dereference_object(commit_id)
    end

    return nil unless obj.is_a?(Rugged::Commit)

    Git::Commit.new(obj)
  rescue Rugged::ReferenceError, Rugged::InvalidError, Rugged::ObjectError, Gitlab::Git::Repository::NoRepository
    nil
  end

  alias last_commit find_commit

  # Commit file in repository and return commit sha
  # options should contain next structure:
  # options = {
  #   file: {
  #     content: 'This is webpacker',
  #     path: 'welcome-to-webpacker.md'
  #   },
  #   commit: {
  #     message: 'Added a post!',
  #     branch: 'master'
  #   }
  # }

  def create_commit(options, action = :add)
    file = options[:file]
    commit = options[:commit]
    branch = commit[:branch]
    parents = []
    mode = 0o100644

    unless branch.start_with?('refs/')
      branch = 'refs/heads/' + branch
    end

    filename = file[:path].to_s
    index = repository.index

    unless repository.empty?
      rugged_ref = repository.references[branch]
      raise Repository::InvalidRef.new('Invalid branch name') unless rugged_ref
      last_commit = rugged_ref.target
      index.read_tree(last_commit.tree)
      parents = [last_commit]
    end

    if action == :remove
      index.remove(filename)
    else
      file_entry = index.get(filename)

      if action == :rename
        old_path_name = file[:previous_path].to_s
        old_filename = old_path_name.to_s
        file_entry = index.get(old_filename)
        index.remove(old_filename) unless file_entry.blank?
      end

      mode = file_entry[:mode] if file_entry && file_entry[:mode]
      content = file[:content]
      oid = repository.write(content, :blob)
      index.add(path: filename, oid: oid, mode: mode)
    end

    opts = {}
    opts[:tree] = index.write_tree(repository)
    opts[:author] = committer_hash
    opts[:committer] = committer_hash
    opts[:message] = commit[:message]
    opts[:parents] = parents
    opts[:update_ref] = branch

    Rugged::Commit.create(repository, opts)
  end

  private

  def committer_hash
    {
      email: author.email,
      name: author.name,
      time: Time.now
    }.freeze
  end
end
