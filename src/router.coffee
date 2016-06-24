MeshbluConnectorUpdateController = require './controllers/meshblu-connector-update-controller'

class Router
  constructor: ({@meshbluConnectorUpdateService}) ->

  route: (app) =>
    meshbluConnectorUpdateController = new MeshbluConnectorUpdateController {@meshbluConnectorUpdateService}

    app.post '/start', meshbluConnectorUpdateController.start
    # e.g. app.put '/resource/:id', someController.update

module.exports = Router
