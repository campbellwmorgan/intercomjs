###
# Websockets link and door opener
###
openDoor = _.throttle ->
  $.post '/door'
, 3000, leading: true
playing = false
playAudio = ->
  if playing
    $('#audioStream').remove()
    $('.button.play').removeClass 'playing'
    return playing = false
  $('.button.play')
    .addClass('playing')
    .after $('#audioData').html()
  playing = true

socket = io.connect '/'

socket.on 'buzzer', ->
  alert('door buzzer')

$('.openDoor').click openDoor
$('.play.button').click playAudio

