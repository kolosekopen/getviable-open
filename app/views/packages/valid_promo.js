$('.promo_alert').html("");
$("#promo_code").val("<%= @promo.code%>");
$('.promo_success').html("Success! Your discount of <%= @promo.discount.to_i %>% will be applied at checkout.");