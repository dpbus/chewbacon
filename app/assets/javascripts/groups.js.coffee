# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  if $('#group-weight-chart').length > 0
    Morris.Line
      element: 'group-weight-chart'
      data: $('#group-weight-chart').data('weight')
      xkey: 'date'
      ykeys: $('#group-weight-chart').data('ykeys')
      labels: $('#group-weight-chart').data('ykeys')
      ymin: 'auto'
      postUnits: ' lbs'
  
  $('#group_user_ids').chosen()

jQuery ->
  $('#filter_button').click ->
    if $('#start_date').val() >= $('#end_date').val()
      alert('The start value selected is greater than equal to the end date. Try again.');
      return false;
    else
      return true;
      
jQuery ->
  $('#filter_start').datepicker
    showOn: 'button',
    buttonImage: '/assets/calendar.png',
    buttonImageOnly: true,
    dateFormat: 'yy-mm-dd'
    
jQuery ->
  $('#filter_end').datepicker
    showOn: 'button',
    buttonImage: '/assets/calendar.png',
    buttonImageOnly: true,
    dateFormat: 'yy-mm-dd'