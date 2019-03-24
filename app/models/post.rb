# frozen_string_literal: true

class Post < ApplicationRecord
  include Sluggable
  sluggable source: :title

  belongs_to :person

  validates :status, presence: true
  validates :slug, presence: true, uniqueness: true

  enum status: {
    draft: 0,
    published: 1,
    archived: 2
  }

  delegate :git_repo, to: :person

  def write_to_repo(action: :update)
    author = { email: person.email, name: person.name }
    committer = { email: person.email, name: person.name }
    repo = git_repo
    ref = 'refs/heads/master'
    update_ref = true
    parents = []
    mode = 0o100644

    unless ref.start_with?('refs/')
      ref = 'refs/heads/' + ref
    end


    filename = "#{slug}.md"
    index = repo.index

    unless repo.empty?
      rugged_ref = repo.references[ref]
      raise StandardError, "Invalid branch name" unless rugged_ref
      last_commit = rugged_ref.target
      index.read_tree(last_commit.tree)
      parents = [last_commit]
    end

    if action == :remove
      index.remove(filename)
    else
      file_entry = index.get(filename)

      # if action == :rename
      #   old_path_name = PathHelper.normalize_path(file[:previous_path])
      #   old_filename = old_path_name.to_s
      #   file_entry = index.get(old_filename)
      #   index.remove(old_filename) unless file_entry.blank?
      # end

      if file_entry
        raise StandardError, "Filename already exists; update not allowed" unless true

        # Preserve the current file mode if one is available
        mode = file_entry[:mode] if file_entry[:mode]
      end

      content = body
      oid = repo.write(content, :blob)
      index.add(path: filename, oid: oid, mode: mode)
    end

    opts = {}
    opts[:tree] = index.write_tree(repo)
    opts[:author] = author
    opts[:committer] = committer
    opts[:message] = 'Another commit for update'
    opts[:parents] = parents
    opts[:update_ref] = ref if update_ref

    Rugged::Commit.create(repo, opts)

  end
end
