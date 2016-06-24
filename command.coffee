_             = require 'lodash'
MeshbluConfig = require 'meshblu-config'
Server        = require './src/server'

class Command
  constructor: ->
    @serverOptions =
      meshbluConfig:  new MeshbluConfig().toJSON()
      port:           process.env.PORT || 80
      disableLogging: process.env.DISABLE_LOGGING == "true"
      mongoUri:       process.env.MONGODB_URI

  panic: (error) =>
    console.error error.stack
    process.exit 1

  run: =>
    @panic new Error('Missing required environment variable: MONGODB_URI') if _.isEmpty @serverOptions.mongoUri

    server = new Server @serverOptions
    server.run (error) =>
      return @panic error if error?

      {address,port} = server.address()
      console.log "MeshbluConnectorUpdateService listening on port: #{port}"

    process.on 'SIGTERM', =>
      console.log 'SIGTERM caught, exiting'
      server.destroy()
      process.exit 0

command = new Command()
command.run()
