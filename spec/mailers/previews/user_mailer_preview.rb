# frozen_string_literal: true

class PersonMailerPreview < ActionMailer::Preview
  def send_magic_login
    PersonMailer.with(person: Person.chuspace).send_magic_login
  end
end
