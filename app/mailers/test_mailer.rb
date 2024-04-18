class TestMailer < ApplicationMailer
  def test_email
    mail(to: "sonam.sherpa.lama@gmail.com", subject: "Test Email", body: "This is a test email.")
  end
end
