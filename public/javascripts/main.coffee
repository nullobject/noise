require priority: ["jquery"]

require ["jquery"], ->
  buffer = null

  context = new webkitAudioContext

  delayNode = context.createDelayNode()
  delayNode.delayTime.value = 0.16

  feedbackNode = context.createGainNode()
  feedbackNode.gain.value = 0.25

  filterNode = context.createLowPass2Filter()
  filterNode.cutoff.value = 1000.0
  filterNode.resonance.value = 5.0

  delayNode.connect context.destination
  delayNode.connect filterNode
  filterNode.connect feedbackNode
  feedbackNode.connect delayNode

  playNote = =>
    source = context.createBufferSource()
    source.buffer = buffer
    source.connect context.destination
    source.connect delayNode
    source.noteOn(0)
    setTimeout playNote, 1000

  handler = (data) ->
    buffer = context.createBuffer data, false
    playNote()

  request = new XMLHttpRequest()
  request.open "GET", "http://localhost:4000/sounds/test.wav", true
  request.responseType = "arraybuffer"
  request.onload = -> handler request.response
  request.send()

#   $.get "http://localhost:4000/sounds/test.wav", handler, "text"
