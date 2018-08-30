# frozen_string_literal: true

class SSHKey < ApplicationRecord
  belongs_to :user
end
