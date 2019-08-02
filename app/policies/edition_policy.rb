  # typed: true
  # frozen_string_literal: true

  class EditionPolicy < ApplicationPolicy
    def edit?
      record.persisted? && editor?
    end

    def merge?
      record.may_merge? && author? && record.mergeable?
    end

    def close?
      record.may_close? && author_or_editor?
    end

    def open?
      edit? && record.may_open?
    end

    def destroy?
      record.draft? && edit?
    end

    private

    def author_or_editor?
      author? || editor?
    end

    def author?
      user == record.post.author
    end

    def editor?
      user == record.editor
    end
  end
