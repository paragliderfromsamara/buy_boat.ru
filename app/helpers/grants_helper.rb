module GrantsHelper
  #users_controller grants
  def could_see_users_list?
    user_type == "manager"
  end
  
  def could_see_user?(user = @user)
    user_type == "manager" || current_user == user
  end
  
  def could_add_user?
    user_type == "manager" || user_type == "guest"
  end
  
  def could_modify_user?(user = @user)
    current_user == user || user_type == "manager"
  end
  
  def could_destroy_user?(user = @user)
    could_see_user?(user)
  end
  #end
end
