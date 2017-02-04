class UserMailer < ApplicationMailer
  def welcome(user)
  	@user = user
  	@target_link = "http://#{default_url_options[:host]}/check_user?email=#{user.email}&key=#{user.athority_mail_key}"
    mail(to: user.email, :subject => "Проверка учётной записи") do |format|
      format.text
      format.html
    end
  end
  
  def email_validation(user)
  	@user = user
  	action = 'action_type=email_check'
  	@target_link = "http://#{default_url_options[:host]}/check_user?email=#{user.email}&key=#{user.athority_mail_key}&#{action}"
    mail(to: user.email, :subject => "Проверка E-mail адреса") do |format|
      format.text
      format.html
    end
  end
end
