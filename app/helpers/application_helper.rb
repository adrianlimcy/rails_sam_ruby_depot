module ApplicationHelper
  def hidden_div_if(condition, attributes={}, &block)
    if condition
      attributes["style"] = "display: none"
    end
    content_tag("div", attributes, &block)
  end

  def currency_to_locale(price)
    price = price * 0.87 if 'es' == I18n.locale.to_s
    number_to_currency price
  end

  #def pay_type_options
  #  options_for_select(Hash [Order::PayType.map { |x| [ I18n.('orders.pay_types.' + x.parameterize.underscore), x ]}])
  #end
end
