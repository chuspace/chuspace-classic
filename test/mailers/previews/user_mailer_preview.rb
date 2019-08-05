
class UserMailerPreview < ActionMailer::Preview
  def welcome
    UserMailer.with(user: User.first).welcome
  end

  def send_magic_login
    UserMailer.with(user: User.first).send_magic_login
  end
end
