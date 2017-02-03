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
end
