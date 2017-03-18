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
      boat_type: @boat_type.nil? ? BoatType.first : @boat_type
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
  
  def parseFile #meteo.paraplan.net изображения прикрепляются в pages.coffee.js 
    #link = Rails.root.join("public", "boat_option_combination", "option_combination_1.html")
    #doc = Nokogiri::HTML(open(link), nil, 'utf-8')
    #v = []
    #doc.css('table tr').each do |table|
    #    if !table[:id].blank?
          #opt = ConfiguratorEntity.find_by(param_code: table[:id])
          #v[v.length] = {name: opt.param_name, id: table[:id], amount: table.css('td').last.children.to_s.scan(/\d+/).join.to_i}
    #    end
    #end
    #return "#{v.join('<br/>')}".html_safe
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
