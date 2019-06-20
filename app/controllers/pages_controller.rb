# typed: true
# frozen_string_literal: true

class PagesController < ApplicationController
  def index
    @invite = Invite.new
  end
end
