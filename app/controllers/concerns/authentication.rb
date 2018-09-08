# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate
  end

  def login(person)
    cookies.encrypted[:person_id] = { value: person.id, expires: 1.year.from_now }
  end

  def logout
    cookies.encrypted[:person_id] = nil
  end

  private
  def authenticate
    authenticated_person = Person.find_by(id: cookies.encrypted[:person_id])
    Current.person = authenticated_person
  end

  def authenticate!
    redirect_to root_url unless authenticate
  end
end
