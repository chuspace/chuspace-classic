# frozen_string_literal: true

class ReposController < ApplicationController
  before_action :authenticate!
  around_filter :hypernova_render_support

  def new
  end
end
