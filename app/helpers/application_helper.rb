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
  
  def top_block
    return @top_block if !@top_block.nil?
    {
      boat_type: BoatType.first
      
      
    }
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

  def slider_imgs(imgs) #imgs - это массив содерщий ссылки на фотографии small
    return "" if imgs.blank?
    v = ""
    j=0
    imgs.each do |i|
      t = "data-interchange=\"[#{i.link.wide_small}, small], [#{i.link.wide_medium}, medium], [#{i.link.wide_large}, large], [#{i.link.wide_xlarge}, xlarge]\""
      v += "<li class=\"#{"is-active " if j==0}orbit-slide\">
            <div class = \"rc-slide\" style = \"background-image: url('#{i.link.wide_small}');\" #{t}>
            </div>
           </li>"
      j+= 1
    end
    return v
  end
  
  
  
  def remake_photos
    Photo.all.each do |ph|
      ph.link.recreate_versions!
    end
  end
  
end
