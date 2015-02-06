class DailyMailer < ActionMailer::Base
  default from: "solve.simple.app@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_mailer.digest.subject
  #
  def digest(user)
    @user = user
    @questions = Question.latest

    mail to: user.email, subject: 'Latest questions of SolveSimple'
  end
end