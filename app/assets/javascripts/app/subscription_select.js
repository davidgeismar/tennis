$(document).ready(function() {
  $('.checkbox-subscription').on('change', function() {
    var competitions_selected = $('.checkbox-subscription:checked').map(function() {
      return $(this).prop('id');
    }).get().join(',');

    $('#select_competitions').val(competitions_selected);
  });
});
