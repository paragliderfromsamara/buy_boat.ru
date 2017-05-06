module SessionsHelper

  def sign_in(user)
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    self.current_user = user
    return true
  end
  
  def current_user=(user)
    @current_user = user
  end
   
  def current_user
	  @current_user ||= user_from_remember_token
  end
  
  def user_type
  	if !current_user.nil?
  		@current_user.user_type
  	else
  		user_type = "guest"
  	end
  end
  #управление ключем session_id необходимым для хранения данных в времменных хранилищах
  def get_session_id
    cookies.signed[:session_id]
  end
  
  def set_session_id(ses_id = nil)
    ses_id = make_session_id if ses_id.blank?
    cookies.permanent.signed[:session_id] = ses_id if ses_id != get_session_id
  end
  
  def check_session_id
    if get_session_id.blank?
      if signed_in?
        set_session_id
      else
        set_session_id(u.get_session_id(make_session_id))
      end
    else
      if signed_in?
        if current_user.session_id.blank?
          ex = User.find_by(session_id: get_session_id)
          set_session_id(current_user.get_session_id(ex.nil? ? get_session_id : make_session_id))
        else
          set_session_id(current_user.session_id)
        end
      end
    end
  end
  
  private
  def make_session_id
    Digest::SHA2.hexdigest(%{#{Time.now.to_s}-buy-boats.ru})
  end
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end
    
    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end
    
  	def sign_out
      cookies.delete(:remember_token)
      self.current_user = nil
    end
	
    def signed_in?
      !current_user.nil?
    end
end
