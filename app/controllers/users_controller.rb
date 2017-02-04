class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :prepare_view
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new 
  end

  # GET /users/1/edit
  def edit
  end
  
  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save   
       # url = is_admin? ? user_path(@user) : my_path
        sign_in @user if !signed_in?
        UserMailer.welcome(@user).deliver_now
        format.html { redirect_to current_user == @user ? my_path : @user, notice: "Аккаунт успешно зарегестрирован, на электронный адрес #{@user.email} отправлено проверочное письмо" }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to current_user == @user ? my_path : @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def check
    user = User.athority_mail(params[:key], params[:email])
    redirect_to "/404" and return if user.nil?
    sign_in user if !signed_in?
    flash[:notice] = "E-mail успешно подтверждён" 
    redirect_to my_path
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def prepare_view
      #find in helpers/grants_helper.rb
      f = false
      url = "/404"
      case action_name
      when "index"
        @title = @header = "Список пользователей" 
        f = could_see_users_list?
      when "show"
        @title = @header = is_admin? && current_user != @user ? "Личный кабинет пользователя #{@user.email}"  : "Личный кабинет" 
        f = could_see_user?
      when "new", "create"
        @title = @header = "Регистрация на сайте" 
        f = could_add_user?
        url = my_path 
      when "destroy"
        @title = @header = "Удаление пользователя"
        f = could_destroy_user?
      when "edit", "update"
        @title = @header = "Редактирование пользователя" 
        f = could_modify_user?
      when "check"
        f = (!params[:key].nil? && !params[:email].nil?)
      end
      redirect_to url and return if !f 
    end
    
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :third_name, :email, :phone_number, :post_index, :password, :password_confirmation, :user_type_id, :creator_salt, :creator_email)
    end
end
