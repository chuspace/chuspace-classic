# frozen_string_literal: true

require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @subject = Post.new
  end

  def test_validations
    must validate_presence_of(:slug)
    must validate_uniqueness_of(:slug).case_insensitive
  end


  def test_associations
    must belong_to(:user)
    must belong_to(:repo)
  end
end
