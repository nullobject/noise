require priority: ["jquery", "underscore"]

require ["backbone", "jquery", "underscore"], ->
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
    source.buffer = buffer
    source.connect(context.destination)
    source.connect(feedbackNode)
    source.noteOn(0)

  handler = (data) ->
    buffer = context.createBuffer(data, false)

  request = new XMLHttpRequest()
  request.open("GET", "http://localhost:4000/sounds/test.wav", true)
  request.responseType = "arraybuffer"
  request.onload = -> handler(request.response)
  request.send()

  class Trigger extends Backbone.Model
    defaults:
      selected: false

    toggle: ->
      this.set(selected: !this.get("selected"))

  class TriggerView extends Backbone.View
    tagName: "li"

    events:
      "click": "select"

    initialize: ->
      @model.bind("change", this.render)

    render: =>
      $(@el).toggleClass("selected", @model.get("selected"))

    select: =>
      @model.toggle()

  class TriggerViewController
    constructor: (@el) ->
      _.extend(this, Backbone.Events)
      @triggerViews = []

    addTriggerView: (triggerView) ->
      triggerView.render()
      $(@el).append(triggerView.el)
      @triggerViews.push(triggerView)

  triggerViewController = new TriggerViewController("#triggers")
  triggers = _([0..15]).map ->
    trigger = new Trigger
    triggerView = new TriggerView(model: trigger)
    triggerViewController.addTriggerView(triggerView)
    trigger

  index = 0
  playNextTrigger = ->
    trigger = triggers[index]
    playNote() if trigger.get("selected")
    index++
    index = 0 if index >= 4

  setInterval(playNextTrigger, 500)
