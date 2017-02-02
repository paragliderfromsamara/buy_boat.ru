class SessionsController < ApplicationController
  
  def current_user_page
    redirect_to(new_session_path) and return if !signed_in?
    @user = current_user
    @title = "Личный кабинет"
    render "users/show"
  end
  
  def new
   redirect_to my_path if signed_in? 
	 @title = @header = 'Вход на сайт'
   render layout: false if params[:nolayout] == "true" 
  end

  def create
    redirect_to my_path if signed_in? 
	  @title = @header = 'Вход на сайт'
    @user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if @user.nil?
      flash.now[:alert] = "Неверный email или пароль"
      @title = @header = 'Вход на сайт'
	    respond_to do |format|
	      format.html { render 'new' }
        #format.js {}
      end
    else
      sign_in @user
	    respond_to do |format|
	      format.html { redirect_to my_path }
        #format.js {}
      end
    end
  end

  def destroy
	  sign_out
    redirect_to root_path
  end
end
