# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @subject = User.new
  end

  def test_validations
    must validate_presence_of(:name)
    must validate_presence_of(:email)
    must validate_presence_of(:nickname)
    must validate_uniqueness_of(:email).case_insensitive
    must validate_uniqueness_of(:nickname).case_insensitive
  end


  def test_associations
    must have_one(:repo)
    must have_many(:posts)
  end
end
