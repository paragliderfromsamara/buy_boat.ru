require 'test_helper'

class TrademarkTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  
  test "Тест на провал сохранения торговой марки без названия" do
    trademark = trademarks(:one)
    trademark.name = " "
    assert_not trademark.save, "Удалось сохранить торговую марку с пустым названием"
  end
  
  test "Тест на провал сохранения торговой марки с одинаковыми названиями" do
    trademark_1 = trademarks(:third)
    trademark_2 = trademarks(:two)
    trademark_1.name = trademark_2.name = default_string
    assert trademark_1.save, "Не удалось сохранить тестовый образец"
    trademark_2.name = trademark_1.name
    assert_not trademark_2.save, "Удалось сохранить торговую марку с уже имеющимся названием"
  end
  
  test "Тест на сохраненение значения nil" do 
    trademark = Trademark.new(email: rand_email)
    assert_not trademark.save, "Удалось сохранить значение атрибута name = nil при добавлении новой торговой марки"
    trademark = Trademark.first
    assert trademark.update_attributes(email: rand_email), "Не удалось обновить торговую марку с атрибутом name = nil"
  end
  
end
