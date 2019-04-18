# frozen_string_literal: true

class Contributor
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_reader :errors
  attr_accessor :blog, :filename

  validates_presence_of :filename, :blog

  delegate :rugged, to: :blog

  def initialize(attributes = {})
    super
    @errors = ActiveModel::Errors.new(self)
    validate!
  end

  def contributors
    emails =
      Rugged::Blame.new(rugged, filename).map do |hunk|
        email = hunk.dig(:orig_signature, :email)
        next if email == author.email
        email
      end.compact
        .uniq

    @contributors ||= User.where(email: emails)
  end
end
