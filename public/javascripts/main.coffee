require priority: ["jquery"]

require ["jquery"], ->
  context = new webkitAudioContext
  source = context.createBufferSource()

  source.connect context.destination

  handler = (data) ->
    source.buffer = context.createBuffer data, false
    source.noteOn(0)

  request = new XMLHttpRequest()
  request.open "GET", "http://localhost:4000/sounds/test.wav", true
  request.responseType = "arraybuffer"
  request.onload = -> handler request.response
  request.send()

#   $.get "http://localhost:4000/sounds/test.wav", handler, "text"
