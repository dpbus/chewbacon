$(document).on 'turbolinks:load', ->
  $('#users-groups-menu').hover ->
    $(this).addClass("hover")
    $('#users-groups-nav').css('visibility', 'visible')
  , ->
    $(this).removeClass("hover")
    $('#users-groups-nav').css('visibility', 'hidden')
