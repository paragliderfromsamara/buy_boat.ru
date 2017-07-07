module GrantsHelper
  def is_admin?
    user_type == "admin"
  end
  
  def is_producer?
    user_type == "producer" || is_admin?
  end
  
  def is_manager?
    user_type == "manager" || is_producer?
  end
  
  def is_banned?
    user_type == "banned" 
  end
  
  def is_customer?
    user_type == "customer" 
  end
  #users_controller grants
  def could_see_users_list?
     is_producer?
  end
  
  def could_see_user?(user = @user)
    is_producer? || current_user == user 
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
  def could_manage_boat_parameter_types?
    is_producer?
  end 
  
  #boat_types
  def could_manage_boat_types?
    is_producer?
  end 
  
  #boat_series
  def could_manage_boat_series? 
    is_producer?
  end
  
  #trade_marks
  def could_manage_trademarks?
    is_producer?
  end 
  
  #boat_parameter_values
  def could_modify_boat_parameter_values?
    is_admin?
  end 
  
  #shops
  def could_manage_all_shops?
    is_producer?
  end
  
  def could_modify_shop?(shop=@shop) #может менять статус магазина на открытый/закрытый
    return false if shop.nil?
    return (is_manager? && shop.manager == current_user) || is_producer?
  end
  
  def could_enable_or_disable_shop?  #может активировать и блокировать магазин
    is_producer? 
  end
  
  def could_destroy_shop?(shop=@shop) #может удалять магазин
    (is_producer? and shop.is_recent?) || is_admin?
  end
  
  #photos
  
  def could_destroy_photo?(photo=@photo)
    is_producer?
  end
end
