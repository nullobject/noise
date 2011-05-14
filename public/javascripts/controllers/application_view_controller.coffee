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
      @sampleManager.loadSamples(bass_drum: "/samples/808/bd.wav", snare_drum: "/samples/808/sd.wav")

    _onSampleLoaded: (name, data) =>
      $("#status").text(name + " loaded...")

    _onAllLoaded: =>
      $("#status").text("")
      this._start()

    _initGrid: ->
      @gridViewControllers = []
      @gridViewControllers.push(new GridViewController("bass_drum"))
      @gridViewControllers.push(new GridViewController("snare_drum"))

    _playNote: (sampleName, note) ->
      gain = note.get("gain")

      # Don't play it if we can't hear it.
      return if gain == 0.0

      source            = @audioContext.createBufferSource()
      source.buffer     = @sampleManager.get(sampleName)
      source.gain.value = Math.log(gain + 1) / Math.log(2)

      source.connect(@audioContext.destination)
      source.connect(@feedbackNode)
      source.noteOn(@currentTime + 0.1)

    _start: ->
      index = 0
      note = null

      @currentTime = @audioContext.currentTime

      playNextNote = =>
        _(@gridViewControllers).each (gridViewController) =>
          gridViewController.setActiveCell(index)
          note = gridViewController.pattern.getNote(index)
          this._playNote(gridViewController.sampleName, note)

        index++
        index = 0 if index >= 16

      setInterval(playNextNote, 450)
