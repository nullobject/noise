define ["sample_manager", "trigger", "trigger_view", "trigger_view_controller"], (SampleManager, Trigger, TriggerView, TriggerViewController) ->
  class ApplicationViewController
    constructor: ->

      this._initAudio()
      this._initSampleManager()
      this._initTriggers()

    _initAudio: ->
      @audioContext = new webkitAudioContext

      @delayNode = @audioContext.createDelayNode()
      @delayNode.delayTime.value = 0.25

      @feedbackNode = @audioContext.createGainNode()
      @feedbackNode.gain.value = 0.25

      @delayNode.connect(@audioContext.destination)
      @delayNode.connect(@feedbackNode)
      @feedbackNode.connect(@delayNode)

    _initSampleManager: ->
      @sampleManager = new SampleManager(@audioContext)
      @sampleManager.bind("sample:loaded", this._onSampleLoaded)
      @sampleManager.bind("all:loaded", this._onAllLoaded)
      @sampleManager.loadSamples(kick: "/samples/test.wav")

    _onSampleLoaded: (name, data) =>
      $("#status").text(name + " loaded...")

    _onAllLoaded: =>
      $("#status").text("")
      this._start()

    _initTriggers: ->
      @triggerViewController = new TriggerViewController("#triggers")
      @triggers = _([0..15]).map =>
        trigger = new Trigger
        triggerView = new TriggerView(model: trigger)
        @triggerViewController.addTriggerView(triggerView)
        trigger

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
        index++
        index = 0 if index >= 4
        this._playSample("kick") if trigger.get("selected")

      setInterval(playNextTrigger, 500)
