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
      smooth: false
  
  $('#group_user_ids').chosen()