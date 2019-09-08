# typed: ignore
# frozen_string_literal: true

require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(name: 'Gaurav Tiwari', email: "gaurav-#{Time.now.to_i}@chuspace.com", nickname: "gaurav-#{Time.now.to_i}")
    @invalid_repository = Repository.new
    @valid_repository = Repository.new(name: 'bar', path: Git.config.storage_path.join('bar.git'), author: @user)
  end

  test 'valid?' do
    refute @invalid_repository.valid?
  end

  test 'persisted?' do
    assert @valid_repository.valid?
    refute @valid_repository.persisted?
  end

  test 'create' do
    @valid_repository.create
    assert @valid_repository.persisted?
  end

  test 'destroy' do
    @valid_repository.create
    @valid_repository.destroy
    refute @valid_repository.persisted?
  end

  test 'rename' do
    @valid_repository.create
    @valid_repository.rename(
      path: Git.config.storage_path.join('bar.git'), new_path: Git.config.storage_path.join('baz.git')
    )
    assert @valid_repository.persisted?
  end
end
