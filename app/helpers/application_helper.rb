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
  
  def my_select_list(collection, target_id)
    return "" if collection.blank?
    url = %{<a class="dropdown button float-right" data-toggle="#{target_id}_my_select">Выбрать</a>}
    list_values = ""
    collection.each do |c| 
      list_values += %{
                          <li>
                            <a onclick = '$("##{target_id}").val($.trim($(this).text()));$(this).parents(".dropdown-pane").foundation("close");'>
                                #{c}
                              </a>
                          </li>
                      }
    end
    list_values = %{<div class="dropdown-pane bottom-right " id="#{target_id}_my_select" data-dropdown>
                          <ul class = "entities-menu">
                            #{list_values}
                          </ul>
                    </div>}
    return "#{url}#{list_values}".html_safe
  end
  
  
end
