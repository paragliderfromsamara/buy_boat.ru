module ApplicationHelper
  def page_title(cur_site)
    return @title if !@title.nil?
    case cur_site
    when 'shop'
      return "Купи себе лодку"
    when 'realcraft'
      return t(:default_title)
    when 'salut'
      return "САЛЮТ - моторные лодки"
    when 'control'
      return "Управление"
    end
  end
  
  def production_photos(ph_name, preview_size = "small")
    path_name = "/production_photos"
    return {url: "#{path_name}/#{ph_name}_#{preview_size}.jpg", list: "[#{path_name}/#{ph_name}_small.jpg, small], [#{path_name}/#{ph_name}_medium.jpg, medium], [#{path_name}/#{ph_name}_large.jpg, large], [#{path_name}/#{ph_name}_xlarge.jpg, xlarge]"}
  end
  
  def show_top_image?
    #flag = true
    #disable_on_pages = {
    #                      "users" => [],
    #                      "trademarks" => [],
    #                      "boat_parameter_types" => [],
    #                      "boat_series" => ["new", "edit", "update", "create"],
    #                      "boat_types" => ["manage_index", "create", "update", "new", "edit"],
    #                      "boat_for_sales" => ["manage_index"],
    #                      "boat_option_types" => [],
    #                      "shops" => []
    #                      
    #                   }                     
    #v = disable_on_pages[controller.controller_name]
    #if !v.nil?
    #  flag = !(!v.index(controller.action_name).nil? || v.blank?)
    #end
    return controller.controller_name == "pages" && controller.action_name == "index"
  end
  
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
      boat_type: @boat_type.nil? ? BoatType.active.first : @boat_type
      #sub_menu_items: [{text: "url name", url: link}, ...]
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
  #fromtest
  def alphabet(ru = false)
    "абвгдеёжзийклмнопрстуфхцчшщъыьэюя" if ru
    "abcdefghijklmnopqrstuvwxyz"
  end
  
  def default_numb(n = 6)
    rand 10**(n-1) .. 10**n
  end
  
  def rand_email
    %{#{default_string}@#{default_string}.com}
  end
  
  def default_string(n=6, is_ru = false)
    s = ""
    al =  alphabet(is_ru)
    1.upto(n) do 
      v = rand 2
      l = al[rand(al.size)] 
      s += (v>0) ? l : l.mb_chars.upcase.to_s
    end 
    return s
  end

  
end
