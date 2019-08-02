# typed: false
# frozen_string_literal: true

module Commitable
  extend ActiveSupport::Concern

  def merge_index(commit)
    base = commit
    head = commit
    merge_base = rugged.merge_base(base, head)

    if merge_base == head.oid
      nil
    else
      ancestor_tree = merge_base && Rugged::Commit.lookup(rugged, merge_base).tree
      base.tree.merge(head.tree, ancestor_tree, favor: :normal, renames: true)
    end
  end

  def merge_commit(head, committer, commit_message)
    base = commit
    head = lookup(head)
    commit_message = Rugged.prettify_message(commit_message)
    index = merge_index(head)

    if index && !index.conflicts?
      options = {
        message: commit_message,
        committer: committer ? commit_hash(user: committer) : commit_hash,
        author: commit_hash,
        parents: [base, head],
        tree: index.write_tree(rugged),
        update_ref: 'refs/heads/master'
      }

      [Rugged::Commit.create(rugged, options), nil]
    end
  end
end
