express = require "express"

httpServer = express.createServer()

httpServer.configure ->
  appDir    = __dirname + "/app"
  publicDir = __dirname + "/public"

  httpServer.use express.bodyParser()
  httpServer.use express.compiler(src: appDir, dest: publicDir, enable: ["coffeescript", "less"])
  httpServer.use express.static(publicDir)

httpServer.configure "development", ->
  httpServer.use express.errorHandler(dumpExceptions: true, showStack: true)

httpServer.listen 4000
console.log "Express server listening on port %d", httpServer.address().port
