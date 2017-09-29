module SessionsHelper

  def domains_list
    %w( .myapps.ru .myapps.com .salut-boats.ru .realcraftboats.com .realcraftboats.ru .control.myapps.ru .control.myapps.com )
  end 
  
  def sign_in(user)
    cookies.permanent.signed[:remember_token] = {value: [user.id, user.salt], expires: 1.year.from_now, domain: domains_list}
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
    @user_type ||= current_user.nil? ? "guest" : current_user.user_type
  end
  #управление ключем session_id необходимым для хранения данных в времменных хранилищах
  def get_session_id
    cookies.signed[:session_id]
  end
  
  def set_session_id(ses_id = nil)
    ses_id = make_session_id if ses_id.blank?
    cookies.permanent.signed[:session_id] = {value: ses_id, expires: 1.year.from_now, domain: domains_list} if ses_id != get_session_id
  end
  
  def check_session_id
    if get_session_id.blank?
      if signed_in?
        set_session_id
      else
        set_session_id(make_session_id)
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
      cookies.delete(:remember_token, domain: domains_list)
      self.current_user = nil
      
    end
	
    def signed_in?
      !current_user.nil?
    end
end
