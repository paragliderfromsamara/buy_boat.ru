class SessionsController < ApplicationController
  before_action :check_signed, only: [:new, :create]
  def current_user_page
    redirect_to(signin_path) and return if !signed_in?
    @user = current_user
    @title = "Личный кабинет"
    render "users/show"
  end
  
  def new
	 @title = @header = 'Вход на сайт'
   render layout: false if params[:nolayout] == "true" 
  end

  def create
	  @title = @header = 'Вход на сайт'
    @user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    respond_to do |format|
      if @user.nil?
        format.html {render :new}
        format.js {render js: "$('#session_callback').addClass(\"alert\").html(\"Неверный email или пароль\");"}
      else
        sign_in @user
        format.html {redirect_to my_path}
        format.js {render js: "Turbolinks.visit('/cabinet');"}
      end
    end
  end

  def destroy
	  sign_out
    respond_to do |format|
      format.js {render js: "Turbolinks.visit('#{root_path}');"}
      format.html {redirect_to root_path}
    end
  end
  
  private
  
  def check_signed
    if is_shop?
      #redirect_to my_path if signed_in?
    elsif is_control?
      #redirect_to root_path if signed_in?
    else
      redirect_to '/404'
    end    
  end
end
