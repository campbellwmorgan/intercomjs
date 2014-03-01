_ = require 'lodash'
gpio = require 'gpio'
class Sockets
  constructor: (@io) ->
    @clients = []
    @gpio4 = false
    @listenSockets()
    @listenGPIO()
    @gpioTimeout = false

  listenSockets: =>
    @io.sockets.on 'connection', @addClient
  listenGPIO: =>
    @gpio4 = gpio.export 4,
      direction: 'in'
      interval: 50
      ready: @gpioReady

  gpioReady: =>
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
    client.on 'disconnect', =>
      for oldClient, indx in @clients
        @clients.splice indx if oldClient is client

module.exports = Sockets
