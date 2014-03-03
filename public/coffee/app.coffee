###
# Websockets link and door opener
###

socket = io.connect '/'

ringing = false
stopRinging = ->
  ringing = false
  $('html').removeClass 'ringing'

openDoor = _.debounce ->
  socket.emit 'openDoor' if socket
, 3000
,
  leading: false
  trailing: true

sayHello = _.debounce ->
  return unless ringing
  stopRinging()
  socket.emit 'sayHello' if socket
, 3000
,
  trailing: true


playing = false
playAudio = ->
  if playing
    $('#audioStream').remove()
    $('.button.play').removeClass 'playing'
    return playing = false
  socket.emit 'answer' if socket
  $('.button.play')
    .addClass('playing')
    .after $('#audioData').html()
  playing = true

socket.on 'buzzer', ->
  ringing = true
  $('html').addClass('ringing')
  alert('door buzzer')

socket.on 'answered', stopRinging

$('.openDoor').click openDoor
$('.sayHello').click sayHello
$('.play.button').click playAudio

