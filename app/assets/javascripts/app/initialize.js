$(document).ready(function(){
  $('.datepicker').datepicker({
     format:    'dd/mm/yyyy',
     language:  'fr',
     startDate: '-1d'
  });

  $('[data-toggle="popover"]').popover();
  $('[data-toggle="tooltip"]').tooltip();
});
