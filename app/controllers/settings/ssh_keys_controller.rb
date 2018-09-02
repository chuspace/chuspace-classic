# frozen_string_literal: true

class Settings::SshKeysController < ApplicationController
  before_action :authenticate!

  def index
    @keys = SshKey.all
  end

  def new
  end

  def create
  end

  def destroy
  end
end
