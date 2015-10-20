$(document).ready(function(){
  $('.subscription_item select').change(function(){
    var form = $(this).parent();
    var text = 'Êtes-vous sûr ?';
    var result = confirm(text);

    if (result === true) {
      $(this).parent().submit();
    }
  });
});
$(document).ready(function(){
  $('submit').on('click', function(event){
    x = $('#user_telephone').val();
    $('#user_telephone').val('+33' + x);
  });
});
