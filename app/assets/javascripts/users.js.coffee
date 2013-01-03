# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  if $('#weight-chart').length > 0
    Morris.Line
      element: 'weight-chart'
      data: $('#weight-chart').data('weight')
      xkey: 'date'
      ykeys: ['weight']
      labels: ['Weight']
      ymin: 'auto'
      postUnits: ' lbs'
      smooth: false
      