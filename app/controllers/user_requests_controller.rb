class UserRequestsController < ApplicationController
  before_action :check_signed
  def my_requests
    @user_requests = current_user.user_requests
  end
  
  def create
    if current_user.user_requests.create(user_request_params)
      render json: {status: :ok}
    else
      render json: {status: :canceled}
    end
  end
  
  private
  
  def user_request_params
    params.require(:user_request).permit(:boat_for_sale_id)
  end
  
  def check_signed
    redirect_to "/404" and return if !signed_in?
  end
end
