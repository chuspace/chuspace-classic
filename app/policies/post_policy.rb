  class PostPolicy < ApplicationPolicy
    def edit?(action = '')
      action != 'edit' && record.persisted? && user == record.author
    end

    def contribute?(action = '')
      action == 'show' && record.published? && user != record.author
    end

    def destroy?(action = '')
      action == 'edit' && edit?
    end

    def publish?(action = '')
      action == 'edit' && edit?
    end

    def show?
      record.published?
    end
  end
