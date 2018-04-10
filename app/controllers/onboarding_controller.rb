# frozen_string_literal: true

class OnboardingController < ApplicationController
  skip_before_action :onboard!

  def index
  end
end
