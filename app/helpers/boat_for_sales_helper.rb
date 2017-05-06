module BoatForSalesHelper
  def switch_in_favorites(id)
    f = actual_ids
    if f.index(id).nil?
      f.push(id)
      m = "added"
    else
      f.delete_at(f.index(id))
      m = "deleted"
    end
    set_favorites(f)
    return m
  end
  
  def get_favorites
    return [] if !$redis.exists(favorites_redis_key)
    value = $redis.get(favorites_redis_key)
    return !value.blank? ? JSON.parse(value) : []
  end
  
  private
  
  def actual_ids
    f = get_favorites
    return f.blank? ? [] : BoatForSale.active.where(id: f).ids
  end
  
  def set_favorites(ids=[])
    $redis.del(favorites_redis_key) if $redis.exists(favorites_redis_key)
    $redis.set(favorites_redis_key, ids.to_json, ex: 30.days) if !ids.blank?
  end
  
  def favorites_redis_key
    %{#{get_session_id}:favorites}
  end
end
