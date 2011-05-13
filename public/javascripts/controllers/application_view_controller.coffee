define ["sample_manager", "controllers/grid_view_controller"], (SampleManager, GridViewController) ->
  class ApplicationViewController
    constructor: ->
      this._initAudio()
      this._initSampleManager()
      this._initGrid()

    # TODO: should init the global gain level.
    _initAudio: ->
      @audioContext = new webkitAudioContext

      @delayNode = @audioContext.createDelayNode()
      @delayNode.delayTime.value = 0.333

      @feedbackNode = @audioContext.createGainNode()
      @feedbackNode.gain.value = 0.5

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

    _initGrid: ->
      @gridViewController = new GridViewController("#container")
      @pattern = @gridViewController.pattern

    _playSample: (name) ->
      source = @audioContext.createBufferSource()
      source.buffer = @sampleManager.get(name)
      source.connect(@audioContext.destination)
      source.connect(@feedbackNode)
      source.noteOn(0)

    _start: ->
      index = 0

      playNextNote = =>
        note = @pattern.getNote(index++)
        index = 0 if index >= 16
        this._playSample("kick") if note.get("selected")

      setInterval(playNextNote, 500)
