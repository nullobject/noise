require.ready ->
  context = new webkitAudioContext
  source = context.createBufferSource()

  source.connect(context.destination)

  request = new XMLHttpRequest()
  request.open("GET", "http://localhost:4000/sounds/test.wav", true)
  request.responseType = "arraybuffer"

  request.onload = ->
    source.buffer = context.createBuffer(request.response, false)
    source.noteOn(0)

  request.send()
