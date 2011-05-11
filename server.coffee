express = require "express"
io      = require "socket.io"

httpServer = express.createServer()

httpServer.configure ->
  publicDir = __dirname + "/public"

  httpServer.use express.bodyParser()
  httpServer.use express.compiler(src: publicDir, enable: ["less", "coffeescript"])
  httpServer.use express.static(publicDir)

httpServer.configure "development", ->
  httpServer.use express.errorHandler(dumpExceptions: true, showStack: true)

httpServer.listen 4000
console.log("Express server listening on port %d", httpServer.address().port)
