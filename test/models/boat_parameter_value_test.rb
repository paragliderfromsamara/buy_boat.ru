require 'test_helper'

class BoatParameterValueTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "На сохрание значений атрибутов в верный столбец" do
    test_string = default_string
    test_numb = default_numb
    test_numb_2 = default_numb
    
    val = boat_parameter_types(:string_type).boat_parameter_values.create(set_value: test_string, boat_type_id: boat_types(:one).id)
    val.reload
    assert_equal val.string_value, test_string, "Не удалось сохранить строковое значение атрибута в столбец string_value параметра типа #{val.get_value_type}"
    assert_equal val.get_value, test_string, "Функция get_value выбрала неправильный столбец значения"
    
    val = boat_parameter_types(:integer_type).boat_parameter_values.create(set_value: test_numb, boat_type_id: boat_types(:one).id)
    val.reload
    assert_equal val.integer_value, test_numb, "Не удалось сохранить целочисленное значение атрибута в столбец integer_value параметра типа #{val.get_value_type}"
    assert_equal val.get_value, test_numb, "Функция get_value выбрала неправильный столбец значения"
  
    val = boat_parameter_types(:boolean_type).boat_parameter_values.create(set_value: false, boat_type_id: boat_types(:one).id)
    val.reload
    assert_equal val.bool_value, false, "Не удалось сохранить boolean значение атрибута в столбец bool_value параметра типа #{val.get_value_type}"
    assert_equal val.get_value, false, "Функция get_value выбрала неправильный столбец значения"
    
    val = boat_parameter_types(:float_type).boat_parameter_values.create(set_value: test_numb_2, boat_type_id: boat_types(:one).id)
    val.reload
    assert_equal val.float_value, test_numb_2, "Не удалось сохранить float значение атрибута в столбец float_value параметра типа #{val.get_value_type}"
    assert_equal val.get_value, test_numb_2, "Функция get_value выбрала неправильный столбец значения"
  end
  
  test "Тест на сохрание неправильного формата в столбец string" do
    test_numb = default_numb
    val = boat_parameter_types(:string_type).boat_parameter_values.create(set_value: test_numb, boat_type_id: boat_types(:one).id)
    val.reload 
    assert_equal val.get_value, test_numb.to_s, "Целочисленный тип при сохранение в столбец string_value должен преобразоываться в строку"
    
    val = boat_parameter_types(:string_type).boat_parameter_values.create(set_value: test_numb.to_f, boat_type_id: boat_types(:one).id)
    val.reload 
    assert_equal val.get_value, test_numb.to_f.to_s, "Дробный тип при сохранении в столбец string_value должен преобразоываться в строку"
    
    val = boat_parameter_types(:string_type).boat_parameter_values.create(set_value: false, boat_type_id: boat_types(:one).id)
    val.reload 
    assert_equal val.get_value, false.to_s, "Булевый тип при сохранении в столбец string_value должен преобразоываться в строку"
    
    val = boat_parameter_types(:string_type).boat_parameter_values.create(set_value: nil, boat_type_id: boat_types(:one).id)
    val.reload 
    assert_equal val.get_value, "", "Nil при сохранении в столбец string_value должен преобразоываться в строку"
  end
  
  test "Тест на сохрание неправильного формата в столбец integer" do
    #flunk "Дописать тест на сохрание неправильного формата в столбец integer"
    test_numb = default_numb
    test_string = default_string
    val = boat_parameter_types(:integer_type).boat_parameter_values.create(set_value: test_numb, boat_type_id: boat_types(:one).id)
    val.reload 
    assert_equal val.get_value, test_numb, "Строчный тип при сохранении в столбец integer_value должен преобразоываться в целочисленный"
    
    val = boat_parameter_types(:integer_type).boat_parameter_values.create(set_value: nil, boat_type_id: boat_types(:one).id)
    val.reload 
    assert_equal val.get_value, 0, "nil при сохранении в столбец integer_value должен стать 0"
    
    val = boat_parameter_types(:integer_type).boat_parameter_values.create(set_value: false, boat_type_id: boat_types(:one).id)
    val.reload 
    assert_equal val.get_value, 0, "false при сохранении в столбец integer_value должен преобразоываться в 0"
    
    val = boat_parameter_types(:integer_type).boat_parameter_values.create(set_value: true, boat_type_id: boat_types(:one).id)
    val.reload 
    assert_equal val.get_value, 1, "true при сохранении в столбец integer_value должен преобразоываться в 1"
    
    val = boat_parameter_types(:integer_type).boat_parameter_values.create(set_value: test_numb.to_f, boat_type_id: boat_types(:one).id)
    val.reload 
    assert_equal val.get_value, test_numb, "float при сохранении в столбец integer_value должен преобразоываться в integer"
    
    val = boat_parameter_types(:integer_type).boat_parameter_values.create(set_value: test_string, boat_type_id: boat_types(:one).id)
    val.reload 
    assert_equal val.get_value, 0, "буквы при сохранении в столбец integer_value должны преобразоываться в 0"
  end
  
  
  test "Тест на сохрание неправильного формата в столбец float" do
    #flunk "Дописать тест на сохрание неправильного формата в столбец integer"
    test_numb = default_numb.to_f
    test_string = default_string
    val = boat_parameter_types(:float_type).boat_parameter_values.create(set_value: test_numb, boat_type_id: boat_types(:one).id)
    val.reload 
    assert_equal val.get_value, test_numb, "Строчный тип при сохранении в столбец float_type должен преобразоываться в дробный"
    
    val = boat_parameter_types(:float_type).boat_parameter_values.create(set_value: nil, boat_type_id: boat_types(:one).id)
    val.reload 
    assert_equal val.get_value, 0.0, "nil при сохранении в столбец float_type должен стать 0.0"
    
    val = boat_parameter_types(:float_type).boat_parameter_values.create(set_value: false, boat_type_id: boat_types(:one).id)
    val.reload 
    assert_equal val.get_value, 0.0, "false при сохранении в столбец float_type должен преобразоываться в 0.0"
    
    val = boat_parameter_types(:float_type).boat_parameter_values.create(set_value: true, boat_type_id: boat_types(:one).id)
    val.reload 
    assert_equal val.get_value, 1.0, "true при сохранении в столбец integer_value должен преобразоываться в 1.0"
    
    val = boat_parameter_types(:float_type).boat_parameter_values.create(set_value: test_numb.to_i, boat_type_id: boat_types(:one).id)
    val.reload 
    assert_equal val.get_value, test_numb, "integer при сохранении в столбец integer_value должен преобразоываться в float"
    
    val = boat_parameter_types(:float_type).boat_parameter_values.create(set_value: test_string, boat_type_id: boat_types(:one).id)
    val.reload 
    assert_equal val.get_value, 0, "буквы при сохранении в столбец integer_value должны преобразоываться в 0.0"
  end
  
  
  test "Тест на сохрание неправильного формата в столбец boolean" do
    #flunk "Дописать тест на сохрание неправильного формата в столбец integer"
    test_numb = default_numb
    test_string = default_string
    
    val = boat_parameter_types(:boolean_type).boat_parameter_values.create(set_value: nil, boat_type_id: boat_types(:one).id)
    val.reload 
    assert_equal val.get_value, false, "nil при сохранении в столбец boolean_type должен стать false"
    
    val = boat_parameter_types(:boolean_type).boat_parameter_values.create(set_value: test_numb, boat_type_id: boat_types(:one).id)
    val.reload 
    assert_equal val.get_value, true, "не ноль при сохранении в столбец boolean_type должен преобразоываться в true"
    
    val = boat_parameter_types(:boolean_type).boat_parameter_values.create(set_value: test_string, boat_type_id: boat_types(:one).id)
    val.reload 
    assert_equal val.get_value, true, "буквы при сохранении в столбец boolean_type должны преобразоываться в true"
    
    val = boat_parameter_types(:boolean_type).boat_parameter_values.create(set_value: 0, boat_type_id: boat_types(:one).id)
    val.reload 
    assert_equal val.get_value, false, "0 при сохранении в столбец boolean_type должен преобразоываться в false"
    
    val = boat_parameter_types(:boolean_type).boat_parameter_values.create(set_value: '', boat_type_id: boat_types(:one).id)
    val.reload 
    assert_equal val.get_value, false, "'' при сохранении в столбец boolean_type должны преобразоываться в false"
    
    val = boat_parameter_types(:boolean_type).boat_parameter_values.create(set_value: test_numb.to_f, boat_type_id: boat_types(:one).id)
    val.reload 
    assert_equal val.get_value, true, "дробный не ноль при сохранении в столбец boolean_type должен преобразоываться в true"
    
    val = boat_parameter_types(:boolean_type).boat_parameter_values.create(set_value: 0.0, boat_type_id: boat_types(:one).id)
    val.reload 
    assert_equal val.get_value, false, "0.0 при сохранении в столбец boolean_type должен преобразоываться в false"
    
    val = boat_parameter_types(:boolean_type).boat_parameter_values.create(set_value: 'false', boat_type_id: boat_types(:one).id)
    val.reload 
    assert_equal val.get_value, false, "'false' при сохранении в столбец boolean_type должен преобразоываться в false"
  end
end
