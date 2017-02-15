module GrantsHelper
  def is_admin?
    user_type == "admin"
  end
  
  def is_manager?
    user_type == "manager" || is_admin?
  end
  
  def is_banned?
    user_type == "banned" 
  end
  
  def is_customer?
    user_type == "customer" 
  end
  #users_controller grants
  def could_see_users_list?
    is_manager?
  end
  
  def could_see_user?(user = @user)
    is_manager? || current_user == user 
  end
  
  def could_add_user?
    is_admin? || user_type == "guest"
  end
  
  def could_modify_user?(user = @user)
    if is_admin?
      (user.user_type == "admin" && current_user == user) || user.user_type  != "admin"
    else
      current_user == user && !is_banned?
    end
  end
  
  def could_destroy_user?(user = @user)
    could_modify_user?(user)
    #(current_user == user || is_admin?) && user_type != "banned"
  end
  #end
  
  #boat_parameter_types
  def could_edit_boat_parameter_types?
    is_admin?
  end 
  
  #boat_types
  def could_modify_boat_type?
    is_admin?
  end 
  
  #boat_parameter_values
  def could_modify_boat_parameter_values?
    is_admin?
  end 
end
