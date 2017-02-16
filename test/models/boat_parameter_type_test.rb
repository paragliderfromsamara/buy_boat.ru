require 'test_helper'

class BoatParameterTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  #t.string  "name"
  #t.string  "short_name"
  #t.string  "measure"
  #t.string  "value_type"
  #t.boolean "is_use_on_filter", default: false
  #t.integer "number
  test "Добавить можно только типы параметра с типом значений string, integer, float, bool" do
    val_types = BoatParameterType.accessible_value_types.map {|t| t[1]}
    val_types.each {|t| boat_parameter_type_val_types_test(t)}
    boat_parameter_type_val_types_test(default_string, false)
  end
  
  test "Порядковые номера должны быть упорядочены по умолчанию от 1 до BoatParameterType.all.size" do
    check_number_ordering
  end
  
  test "После удаления типа параметра, атрибут number должен обновиться на всех типах атрибутов, чтобы восстановить порядок" do
    bt = BoatParameterType.create(name: default_string, short_name: default_string, measure: default_string, value_type: "string")
    bt.reload
    number_before = bt.number
    BoatParameterType.all[2].destroy
    bt.reload
    check_number_ordering
    assert_equal number_before-1, bt.number, "number последнего добавленного элемента должен уменьшиться на 1 после удаления типа параметра из середин"
  end
  
  test "Вновь добавленый параметр должен получить number последний от уже существующего" do
    last = BoatParameterType.all.last
    assert last.number > 0
    bt = BoatParameterType.create(name: default_string, short_name: default_string, measure: default_string, value_type: "string")
    bt.reload
    assert_equal bt.number-1, last.number
  end
  
  test "При добавлении нового типа параметра, он должен привязаться к каждой лодке с флагом is_binded == false" do 
    boat_type = BoatType.all
    bt = BoatParameterType.new(name: default_string, short_name: default_string, measure: default_string, value_type: "string")
    assert_difference('BoatParameterValue.count', boat_type.size) do
      bt.save
    end 
    bt.reload
    assert_equal bt.boat_parameter_values.first.is_binded, false, message: "параметр должен привязываться к каждой лодке с флагом is_binded == false"
  end
  
  test "При добавлении нового атрибута, он должен создаться в каждой лодке с флагом is_binded == false" do 
    boat_type = BoatType.all
    bt = BoatParameterType.new(name: default_string, short_name: default_string, measure: default_string, value_type: "string")
    assert_difference('BoatParameterValue.count', boat_type.size) do
      bt.save
    end 
    bt.reload
    assert_equal bt.boat_parameter_values.first.is_binded, false, message: "параметр должен привязываться к каждой лодке с флагом is_binded == false"
  end
  
  test "При обновлении типа параметра должно быть невозможным изменить тип значения" do
     bt = BoatParameterType.create(name: default_string, short_name: default_string, measure: default_string, value_type: "string")
     bt.reload
     before_type = bt.value_type
     bt.update_attribute(:value_type, "float")
     bt.reload
     assert_not_equal before_type, bt.value_type
  end
  
  test "После удаления типа параметра должны удалиться все связанные BoatParameterValues" do
     bt = BoatParameterType.create(name: default_string, short_name: default_string, measure: default_string, value_type: "string")
     bt.reload
     assert_difference('BoatParameterValue.count', -BoatType.count) do
       bt.destroy
     end 
  end
  
  private

  def check_number_ordering
    flag = true
    i = 1
    BoatParameterType.all.each do |t|
      break if !flag
      flag = i == t.number
      i+=1
    end
    assert flag
  end
  def boat_parameter_type_val_types_test(type, is_good = true)
    bt = BoatParameterType.new(name: default_string, short_name: default_string, measure: default_string, value_type: type)
    assert_equal is_good, bt.save, message: "#{is_good ? "НЕ " : ''}Удалось добавить тип параметра #{type}"
  end
end
