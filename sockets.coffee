Player = require 'player'
_ = require 'lodash'
gpio = require 'gpio'
player = new Player(__dirname + '/audio/hello.mp3')
class Sockets
  constructor: (@io) ->
    @clients = []
    @gpio4 = false
    @gpio0 = false
    @gpio0InProcess = false
    @listenSockets()
    @listenGPIO()
    @gpioTimeout = false

  listenSockets: =>
    @io.sockets.on 'connection', @addClient
  listenGPIO: =>

    @gpio0 = gpio.export 0,
      direction: 'out'
      interval: 200
    @gpio4 = gpio.export 4,
      direction: 'in'
      interval: 50
      ready: @gpio4Ready

    setTimeout =>
      console.log 'setting 1'
      @gpiO.set 1
    , 2000


  gpio4Ready: =>
    @gpio4.on 'change', (val) =>
      clearTimeout @gpioTimeout if val is 0
      @gpioTimeout = setTimeout @alertClients, 100 if val is 1

  # called when pin 4 goes to high
  # for 2 consecutive moments
  alertClients: =>
    console.log 'alerting clients'
    _.invoke @clients, 'emit', [
      'buzzer'
    ]

  addClient: (client) =>
    @clients.push client
    client.on 'openDoor', @openDoor
    client.on 'sayHello', @sayHello
    client.on 'makeRing', @alertClients
    client.on 'answer', @emitAnswered
    client.on 'disconnect', =>
      for oldClient, indx in @clients
        @clients.splice indx if oldClient is client

  # send to all clients
  # that door has been answered
  emitAnswered: =>
    _.invoke @clients, 'emit', ['answered']

  sayHello: =>
    @emitAnswered()
    # run say hello logic
    player.play()

  # go high on 17 (ie open door)
  goHigh0: =>
    console.log 'try opening door'

    # don't open door if gpio17 not ready to access
    # don't run if the door open sequence in process
    return if @gpio0InProcess

    console.log 'opening door...'
    # go high
    @gpio0InProcess = true
    @gpio0.set 0
    # wait 200ms then go low
    setTimeout =>
      @gpio.set 1
      console.log 'door open sequence finished'
      @gpio0InProcess = false
    , 100

  openDoor: =>
    @emitAnswered()
    # run open door stuff
    @goHigh0()

module.exports = Sockets
