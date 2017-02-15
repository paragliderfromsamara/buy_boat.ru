module ApplicationHelper
  def my_collection_select_from_hash(hash_array, form_name, input_name, prompt = "", key = :id, value = :value, default_key = nil)
    collection = ""
    if !hash_array.blank?
      def_val_string = ""
      hash_array.each do |v| 
        if v[key] === default_key 
          def_val_string +=%{<option value = "#{v[key]}">#{v[value]}</option>} 
        else
          collection += %{<option value = "#{v[key]}">#{v[value]}</option>} 
        end
      end
      
    end
    return %{<select name = "#{form_name}[#{input_name}]" id = "#{form_name}_#{input_name}">#{def_val_string}#{collection}</select>}
  end
  
  def menu_items
    menu = {left: [], right: []}
    menu[:right] = signed_in? ? [{url: my_path, name: "Моя лодка (0)"},{url: my_path, name: "Кабинет"},{url: signout_path, name: "Выйти"}] : [{url: signin_path, name: "Вход"}, {url: signup_path, name: "Регистрация"}]
    menu[:left] = [
                    {url: boat_types_path, name: "Подобрать лодку"},
                    {url: boat_types_path, name: "Лодки в наличии"}
                  ] 
  
    if is_manager?
      control_menu = []
      control_menu[control_menu.length] = {url: users_path, name: "Пользователи"}
      control_menu[control_menu.length] = {url: trademarks_path, name: "Торговые марки"} 
      control_menu[control_menu.length] = {url: manage_boat_types_path, name: "Типы лодок"}
      control_menu[control_menu.length] = {url: boat_series_index_path, name: "Серии лодок"}
      control_menu[control_menu.length] = {url: boat_parameter_types_path, name: "Таблица характеристик лодок"} 
      c = [{url: "#", name: "Управление", dropdown: control_menu}]
      menu[:right] = c + menu[:right]
    end
    
    return menu
  end
  
  
  def my_select_list(collection, target_id)
    return "" if collection.blank?
    url = %{<a class="dropdown button float-right" data-toggle="#{target_id}_my_select">Выбрать</a>}
    list_values = ""
    collection.each do |c| 
      next if c.blank?
      list_values += %{
                          <li>
                            <a onclick = '$("##{target_id}").val($.trim($(this).text()));$(this).parents(".dropdown-pane").foundation("close");'>
                                #{c}
                              </a>
                          </li>
                      }
    end
    list_values = %{<div class="dropdown-pane bottom-right entities-menu" id="#{target_id}_my_select" data-dropdown>
                          <ul>
                            #{list_values}
                          </ul>
                    </div>}
    return "#{url}#{list_values}".html_safe
  end


  
end
