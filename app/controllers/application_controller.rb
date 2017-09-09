class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  before_action :check_session_variables, :set_site
  
  include ApplicationHelper
  include MultiSitesControlHelper
  include SessionsHelper
  include GrantsHelper
  
  
  
  def set_site
    if is_realcraft?
      set_locale
    elsif is_control?
      redirect_to signin_path if !is_admin? and !is_producer? and !is_manager? and self.controller_name != 'sessions' #перенаправляем на страницу входа если вход в режим админ меню
    end
  end
  
  private 
  
  def set_locale
    I18n.locale = extract_locale_from_tld || I18n.default_locale
  end
  
  def extract_locale_from_tld
    parsed_locale = request.host.split('.').last
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end
  
  def check_session_variables
    #check_session_id #sessions_helper.rb
  end 

end
