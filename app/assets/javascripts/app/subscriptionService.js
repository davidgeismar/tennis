$('.subscription_item select').change(function(){
  $(this).parent().submit()
});

$('submit').on('click', function(event){
x = $("#user_telephone").val();
$("#user_telephone").val("+33" + x);
});

