class MeshbluConnectorUpdateService
  constructor: ({ @datastore }) ->
  start: ({ uuid, token, connector }, callback) =>
    callback()

  _createError: (code, message) =>
    error = new Error message
    error.code = code if code?
    return error

module.exports = MeshbluConnectorUpdateService
