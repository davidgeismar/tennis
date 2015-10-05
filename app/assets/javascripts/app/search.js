$(document).ready(function() {
  var delay = (function(){
    var timer = 0;

    return function(callback, ms){
      clearTimeout (timer);
      timer = setTimeout(callback, ms);
    };
  })();

  $('#search_input').keyup(function() {
    delay(function(){
      var content = $('#search_input').val();
       $.get( "tournaments/search/" + content , function( data ) {
          $( ".result" ).html( data );
          alert( "Load was performed." );
      });
    }, 500);
  });
});
