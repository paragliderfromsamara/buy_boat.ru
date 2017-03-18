ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  
  def default_users(password="123456")
    v = User.user_types.map{ |type| {email: rand_email, password: password, password_confirmation: password, user_type_id: type[:id], creator_email: users(:admin).email, creator_salt: users(:admin).salt }}
    users = User.create v
    return users
  end
  
  def create_users_list(password="123456")
    v = {}
    u = default_users(password)
    u.each {|usr| v[usr.user_type.to_sym] = usr }
    return v
  end
  
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
  
  
  def rand_boolean
    rand(2) == 0
  end
  
  def make_random_good_entities
    entities = []
    arr_id = 1
    stds = default_numb(1)+1
    steps = rand(10) + 5
    #добавляем группу для стандарта
    entities.push(make_group(1, arr_id))
    #добавляем стандарты
    stds.times do |std|
      arr_id+=1
      entities.push(make_standart(2, arr_id))
    end
    #формируем группы первого уровня
    steps.times do |s|
      arr_id += 1
      entities.push(make_group(1, arr_id))
      options = rand(10)
      has_sub_groups = rand_boolean
      options.times do |opt|
        arr_id += 1
        entities.push(make_option(2, arr_id))
      end
      
      if has_sub_groups 
        sub_groups = rand(10) + 1
        sub_groups.times do |sg|
          arr_id += 1
          options = rand(10)
          entities.push(make_group(2, arr_id))
          options.times do |opt|
            arr_id += 1
            entities.push(make_option(2, arr_id))
          end 
        end
      end
        
    end
    return entities
  end

  
  def make_group(rec_lvl, arr_id, has_code=false)
    v = configurator_entity_template
    v[:rec_level] = rec_lvl
    v[:arr_id] = arr_id
    v[:rec_type] = Configurator.rec_type_group
    v[:param_name] = "#{Configurator.rec_type_group}_#{arr_id}"
    if has_code
      v[:param_code] = default_string(10)
      v[:price] = rand(300000)
    end
    return v
  end
  
  def make_option(rec_lvl, arr_id, has_code=true)
    v = configurator_entity_template
    v[:param_name] = "#{Configurator.rec_type_option}_#{arr_id}"
    v[:rec_level] = rec_lvl
    v[:rec_type] = Configurator.rec_type_option
    v[:param_code] = default_string(10)
    v[:price] = rand(300000) 
    return v
  end
  
  def make_standart(rec_lvl, arr_id)
    v = configurator_entity_template
    v[:param_name] = "#{Configurator.rec_type_standart}_#{arr_id}"
    v[:rec_type] = Configurator.rec_type_standart
    v[:param_code] = default_string(10)
    v[:price] = rand(300000)
    v[:rec_level] = rec_lvl
    return v
  end
  
  def configurator_entity_template
    {
      param_code: "",
      rec_level: 0, #список возможных значений в Configurator.rec_types
      rec_type: "", # список возможных значений в Configurator.rec_types
      hidden: rand_boolean,
      group_hidden: rand_boolean,
      rec_fixed_invisibility: "",
      param_name: default_string,
      comment: default_string,
      checked: rand_boolean,
      start_enabled: rand_boolean
    }
  end
  
  
  
  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
  # Add more helper methods to be used by all tests here...
end
