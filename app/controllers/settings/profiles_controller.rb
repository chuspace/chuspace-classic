# frozen_string_literal: true

class Settings::ProfilesController < ApplicationController
  before_action :authenticate!

  def index
    @person = Current.person
  end
end
