class MeshbluConnectorUpdateController
  constructor: ({@meshbluConnectorUpdateService}) ->

  start: (request, response) =>
    { uuid, token } = request.meshbluAuth
    { connector } = request.params
    @meshbluConnectorUpdateService.start { uuid, token, connector }, (error) =>
      return response.sendError error if error?
      response.sendStatus 200

module.exports = MeshbluConnectorUpdateController
