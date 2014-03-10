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
  $('.openDoor').addClass 'opening'
  setTimeout ->
    $('.openDoor').removeClass 'opening'
  , 2000
, 3000
,
  leading: true
  trailing: false

sayHello = _.debounce ->
  #return unless ringing
  stopRinging()
  if socket
    socket.emit 'sayHello'
    $('.sayHello').addClass 'playing'
    setTimeout ->
      $('.sayHello').removeClass 'playing'
    , 2000
, 3000
,
  leading: true


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

