# typed: ignore
# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @invalid_user = User.new
    @valid_user = User.new(name: 'Foo Bar', nickname: 'FOO', email: 'FOO@bar.com')
  end

  test 'user without valid attributes' do
    @invalid_user = User.new
    refute @invalid_user.valid?
    assert_equal "Email can't be blank. should be a valid email and Email is not a valid email",
                 @invalid_user.errors.full_messages_for(:email).to_sentence
  end

  test 'user with valid attributes' do
    assert @valid_user.valid?

    assert_equal 'Foo', @valid_user.first_name
    assert_equal 'FB', @valid_user.initials
    assert_equal 'foo', @valid_user.nickname
    assert_equal 'foo@bar.com', @valid_user.email
    assert_equal '', @valid_user.auth_token
    assert_nil @valid_user.auth_token_expires_at
  end

  test 'a valid non-saved user should have a publication but no repository' do
    assert @valid_user.valid?
    refute_nil @valid_user.publication

    assert_equal 'Foo Bar', @valid_user.publication.name
    assert_equal 'foo-bar', @valid_user.publication.slug
    assert_equal 'foo.git', @valid_user.publication.repo_name
    assert_equal Git.config.storage_path.join('foo.git').to_s, @valid_user.publication.repo_path
    assert_equal @valid_user, @valid_user.publication.owner
  end

  test 'a valid saved user should have a publication and repository' do
    @valid_user.save

    refute_nil @valid_user.publication.repository
    refute_nil @valid_user.publication
  end
end
