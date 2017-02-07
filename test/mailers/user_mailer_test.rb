require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "Welcome mail" do 
    customer_email = UserMailer.welcome(users(:customer))
    manager_email = UserMailer.welcome(users(:manager))
    # Отправить письмо, затем проверить, что оно попало в очередь
    assert_emails 2 do
      customer_email.deliver_now
      manager_email.deliver_now
    end
   # m = ActionMailer::Base.deliveries.last
  #  url_for_manager = %{http://localhost:3000/check_email?email=#{users(:manager).email}&key=#{users(:manager).athority_mail_key}}
  #  url_for_customer =%{http://localhost:3000/check_email?email=#{users(:customer).email}&key=#{users(:customer).athority_mail_key}}
    # Проверить тело отправленного письма, что оно содержит то, что мы ожидаем
    assert_equal ['noreply@buy-boats.ru'], customer_email.from
    assert_equal [users(:customer).email], customer_email.to
    assert_equal 'Проверка учётной записи', customer_email.subject
    
    assert_equal ['noreply@buy-boats.ru'], manager_email.from
    assert_equal [users(:manager).email], manager_email.to
    assert_equal 'Проверка учётной записи', manager_email.subject
  end
end
