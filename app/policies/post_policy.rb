  # typed: true
  # frozen_string_literal: true

  class PostPolicy < ApplicationPolicy
    def edit?
      record.persisted? && user == record.author
    end

    def contribute?
      record.published? && user != record.author && contributions_ids.exclude?(record.id)
    end

    def contributed?
      contributions_ids.include?(record.id)
    end

    def destroy?
      edit?
    end

    def publish?
      edit? && record.outdated?
    end

    def show?
      record.published?
    end

    def view_editions?
      record.editions.open.any?
    end

    private

    def contributions_ids
      @contributions_ids ||= user.contributions.open.pluck(:post_id)
    end
  end
