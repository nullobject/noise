require priority: ["jquery"]

require ["jquery"], ->
  context = new webkitAudioContext
  source = context.createBufferSource()

  delayNode = context.createDelayNode()
  delayNode.delayTime.value = 0.25

  feedbackNode = context.createGainNode()
  feedbackNode.gain.value = 0.75

  filterNode = context.createLowPass2Filter()
  filterNode.cutoff.value = 1000.0
  filterNode.resonance.value = 5.0

  source.connect context.destination

  source.connect delayNode
  delayNode.connect context.destination

  delayNode.connect filterNode
  filterNode.connect feedbackNode
  feedbackNode.connect delayNode

  handler = (data) ->
    source.buffer = context.createBuffer data, false
    source.noteOn(0)

  request = new XMLHttpRequest()
  request.open "GET", "http://localhost:4000/sounds/test.wav", true
  request.responseType = "arraybuffer"
  request.onload = -> handler request.response
  request.send()

#   $.get "http://localhost:4000/sounds/test.wav", handler, "text"
