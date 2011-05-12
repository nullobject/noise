require priority: ["jquery", "underscore"]

require ["backbone", "jquery", "underscore", "application_view_controller"], (Backbone, JQuery, Underscore, ApplicationViewController) ->
  applicationViewController = new ApplicationViewController

  buffer = null

  context = new webkitAudioContext

  delayNode = context.createDelayNode()
  delayNode.delayTime.value = 0.25

  feedbackNode = context.createGainNode()
  feedbackNode.gain.value = 0.25

  delayNode.connect(context.destination)
  delayNode.connect(feedbackNode)
  feedbackNode.connect(delayNode)

  playNote = =>
    source = context.createBufferSource()
#     source.buffer = @applicationViewController.sampleManager.get("/sounds/test.wav")
    source.buffer = buffer
    source.connect(context.destination)
    source.connect(feedbackNode)
    source.noteOn(0)

  handler = (data) ->
    buffer = context.createBuffer(data, false)

  request = new XMLHttpRequest()
  request.open("GET", "/sounds/test.wav", true)
  request.responseType = "arraybuffer"
  request.onload = -> handler(request.response)
  request.send()

  index = 0
  playNextTrigger = ->
    trigger = applicationViewController.triggers[index]
    playNote() if trigger.get("selected")
    index++
    index = 0 if index >= 4

  setInterval(playNextTrigger, 500)
