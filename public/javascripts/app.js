// Generated by CoffeeScript 1.6.3
/*
# Websockets link and door opener
*/


(function() {
  var openDoor, playAudio, playing, ringing, sayHello, socket, stopRinging;

  socket = io.connect('/');

  ringing = false;

  stopRinging = function() {
    ringing = false;
    return $('html').removeClass('ringing');
  };

  openDoor = _.debounce(function() {
    if (socket) {
      socket.emit('openDoor');
    }
    $('.openDoor').addClass('opening');
    return setTimeout(function() {
      return $('.openDoor').removeClass('opening');
    }, 2000);
  }, 3000, {
    leading: true,
    trailing: false
  });

  sayHello = _.debounce(function() {
    stopRinging();
    if (socket) {
      socket.emit('sayHello');
      $('.sayHello').addClass('playing');
      return setTimeout(function() {
        return $('.sayHello').removeClass('playing');
      }, 2000);
    }
  }, 3000, {
    leading: true
  });

  playing = false;

  playAudio = function() {
    if (playing) {
      $('#audioStream').remove();
      $('.button.play').removeClass('playing');
      return playing = false;
    }
    if (socket) {
      socket.emit('answer');
    }
    $('.button.play').addClass('playing').after($('#audioData').html());
    return playing = true;
  };

  socket.on('buzzer', function() {
    ringing = true;
    $('html').addClass('ringing');
    return alert('door buzzer');
  });

  socket.on('answered', stopRinging);

  $('.openDoor').click(openDoor);

  $('.sayHello').click(sayHello);

  $('.play.button').click(playAudio);

}).call(this);
