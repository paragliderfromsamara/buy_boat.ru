class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  before_action :check_session_variables
  
  include ApplicationHelper
  include SessionsHelper
  include GrantsHelper
  
  private
  
  def check_session_variables
    check_session_id #sessions_helper.rb
  end 

end
