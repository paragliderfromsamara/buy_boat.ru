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
  
  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
  # Add more helper methods to be used by all tests here...
end
