# frozen_string_literal: true

require 'test_helper'

class RepoTest < ActiveSupport::TestCase
  def setup
    @subject = Repo.new
  end

  def test_validations
    must validate_presence_of(:slug)
    must validate_presence_of(:name)
    must validate_uniqueness_of(:slug).scoped_to(:user_id).case_insensitive
  end


  def test_associations
    must belong_to(:user)
  end
end
