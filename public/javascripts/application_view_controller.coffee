define ["sample_manager", "trigger", "trigger_view", "trigger_view_controller"], (SampleManager, Trigger, TriggerView, TriggerViewController) ->
  class ApplicationViewController
    constructor: ->
      @audioContext = new webkitAudioContext

      this._initSampleManager()
      this._initTriggers()
      this._initAudioRouting()
      this._start()

    _initSampleManager: ->
      @sampleManager = new SampleManager(@audioContext)
      @sampleManager.loadSamples(kick: "/sounds/test.wav")

    _initTriggers: ->
      @triggerViewController = new TriggerViewController("#triggers")
      @triggers = _([0..15]).map =>
        trigger = new Trigger
        triggerView = new TriggerView(model: trigger)
        @triggerViewController.addTriggerView(triggerView)
        trigger

    _initAudioRouting: ->
      @delayNode = @audioContext.createDelayNode()
      @delayNode.delayTime.value = 0.25

      @feedbackNode = @audioContext.createGainNode()
      @feedbackNode.gain.value = 0.25

      @delayNode.connect(@audioContext.destination)
      @delayNode.connect(@feedbackNode)
      @feedbackNode.connect(@delayNode)

    _playSample: (name) ->
      source = @audioContext.createBufferSource()
      source.buffer = @sampleManager.get(name)
      source.connect(@audioContext.destination)
      source.connect(@feedbackNode)
      source.noteOn(0)

    _start: ->
      index = 0

      playNextTrigger = =>
        trigger = @triggers[index]
        this._playSample("kick") if trigger.get("selected")
        index++
        index = 0 if index >= 4

      setInterval(playNextTrigger, 500)
