# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('#weigh_in_date').datepicker
    showOn: 'button',
    buttonImage: '/assets/calendar.png',
    buttonImageOnly: true,
    dateFormat: 'yy-mm-dd'