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
    assert_equal @invalid_user.errors.full_messages_for(:email).to_sentence, "Email can't be blank and Email is not a valid email"
  end

  test 'user with valid attributes' do
    assert @valid_user.valid?

    assert_equal @valid_user.first_name, 'Foo'
    assert_equal @valid_user.initials, 'FB'
    assert_equal @valid_user.nickname, 'foo'
    assert_equal @valid_user.email, 'foo@bar.com'
    assert_equal @valid_user.auth_token, ''
    assert_nil @valid_user.auth_token_expires_at
  end

  test 'a valid non-saved user should have a publication but no repository' do
    assert @valid_user.valid?
    refute_nil @valid_user.publication

    assert_equal @valid_user.publication.name, 'Foo Bar'
    assert_equal @valid_user.publication.slug, 'foo'
    assert_equal @valid_user.publication.repo_name, 'blog'
    assert_equal @valid_user.publication.repo_full_name, 'foo/blog.git'
    assert_equal @valid_user.publication.repo_path, Git.config.storage_path.join('foo/blog.git').to_s
    assert_equal @valid_user.publication.owner, @valid_user
  end

  test 'a valid saved user should have a publication and repository' do
    @valid_user.save

    refute_nil @valid_user.publication.repository
    refute_nil @valid_user.publication
  end
end
