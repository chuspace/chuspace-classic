# typed: false
# frozen_string_literal: true

require 'test_helper'

class PublicationTest < ActiveSupport::TestCase
  def setup
    @invalid_publication = Publication.new
    @avatar = Rails.root.join('test', 'fixtures', 'files', 'publication.jpeg').read
    @valid_publication =
      Publication.create(
        name: 'Ruby',
        slug: 'ruby',
        description: 'Ruby publication',
        avatar: StringIO.new(@avatar),
        owner: users(:gaurav)
      )
  end

  test 'an invalid publication should not have a repository' do
    refute @invalid_publication.valid?
    refute @invalid_publication.repository.persisted?
    refute @invalid_publication.repository.present?
    assert @invalid_publication.repository.blank?
  end

  test 'a valid publication should have a repository' do
    refute_nil @valid_publication.repository
    assert @valid_publication.repository.persisted?
    assert @valid_publication.repository.present?
    refute @valid_publication.repository.blank?
    assert @valid_publication.repository.valid?

    assert_equal Git.config.storage_path.join('ruby.git').to_s, @valid_publication.repository.path
    assert_equal 'refs/heads/master', @valid_publication.repository.head.name
    assert_equal 4, @valid_publication.repository.blobs.count
  end

  test 'deleting publication should delete repository' do
    assert @valid_publication.destroy
    assert @valid_publication.repository.blank?
    refute @valid_publication.repository.persisted?
  end

  test 'renaming publication should rename repository' do
    assert @valid_publication.update(name: 'Crystal', slug: 'crystal')
    assert @valid_publication.repository.persisted?
    assert_equal Git.config.storage_path.join('crystal.git').to_s, @valid_publication.repository.path
  end

  test 'should not able to create more than one personal publication but unlimited publications' do
    user = User.create(name: 'John Doe', nickname: 'johndoe', email: 'john@doe.com')
    assert user.publication.persisted?
    assert user.publication.repository.persisted?
    assert user.publication.personal

    new_publication =
      user.publications.create(
        name: 'Java',
        slug: 'java',
        description: 'Java publication',
        avatar: StringIO.new(@avatar),
        owner: user,
        personal: true
      )
    refute new_publication.valid?

    new_publication =
      user.publications.create(
        name: 'Java',
        slug: 'java',
        description: 'Java publication',
        avatar: StringIO.new(@avatar),
        owner: user,
        personal: false
      )
    refute new_publication.valid?
    assert_equal ["is invalid. It must begin set to either 'nil' or 'true'"], new_publication.errors.messages[:personal]

    new_publication =
      user.publications.create(
        name: 'Java', slug: 'java', description: 'Java publication', avatar: StringIO.new(@avatar), owner: user
      )
    assert new_publication.valid?
  end
end
