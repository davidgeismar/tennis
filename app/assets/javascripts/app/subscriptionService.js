$('.subscription_item select').change(function(){
  var form = $(this).parent();
  var text = "Etes vous sur ?";
  var result = confirm(text);

  if (result == true) {
    $(this).parent().submit();
  }
});

$('submit').on('click', function(event){
x = $("#user_telephone").val();
$("#user_telephone").val("+33" + x);
});

