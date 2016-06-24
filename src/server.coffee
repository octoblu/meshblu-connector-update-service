cors               = require 'cors'
morgan             = require 'morgan'
express            = require 'express'
bodyParser         = require 'body-parser'
errorHandler       = require 'errorhandler'
enableDestroy      = require 'server-destroy'
SendError          = require 'express-send-error'
MeshbluAuth        = require 'express-meshblu-auth'
meshbluHealthcheck = require 'express-meshblu-healthcheck'
mongojs            = require 'mongojs'
Router             = require './router'
MeshbluConnectorUpdateService = require './services/meshblu-connector-update-service'
debug              = require('debug')('meshblu-connector-update-service:server')

class Server
  constructor: ({ @disableLogging, @port, @meshbluConfig, @mongoUri })->

  address: =>
    @server.address()

  run: (callback) =>
    app = express()
    app.use SendError()
    app.use meshbluHealthcheck()
    app.use morgan 'dev', immediate: false unless @disableLogging
    app.use cors()
    app.use errorHandler()
    app.use bodyParser.urlencoded limit: '1mb', extended : true
    app.use bodyParser.json limit : '1mb'

    meshbluAuth = new MeshbluAuth @meshbluConfig
    app.use meshbluAuth.get()
    app.use meshbluAuth.gateway()

    app.options '*', cors()

    datastore = mongojs @mongoUri
    meshbluConnectorUpdateService = new MeshbluConnectorUpdateService { datastore }
    router = new Router {@meshbluConfig, meshbluConnectorUpdateService}

    router.route app

    @server = app.listen @port, callback
    enableDestroy @server

  stop: (callback) =>
    @server.close callback

  destroy: =>
    @server.destroy()

module.exports = Server
