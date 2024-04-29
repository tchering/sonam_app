class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(user) # the value in this user will be passed or is passed from user.rb when calling account_activation(self). Self is the user object
    # @greeting = "Hi"
    @user = user

    # mail to: "to@example.org"
    mail to: user.email, subject: "Account activation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #

  #when calling this method from user.rb we will pass the user object as an argument
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
end
