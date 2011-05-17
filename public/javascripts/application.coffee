define ["sample_manager", "models/note", "models/pattern", "models/instrument", "models/kit", "controllers/kit_view_controller"], (SampleManager, Note, Pattern, Instrument, Kit, KitViewController) ->
  class Application
    samples:
      bass_drum:    "/samples/808/bd.wav"
      snare_drum:   "/samples/808/sd.wav"
      closed_hihat: "/samples/808/ch.wav"
      open_hihat:   "/samples/808/oh.wav"
      clap:         "/samples/808/cp.wav"
      clave:        "/samples/808/cl.wav"
      cowbell:      "/samples/808/cb.wav"
      rimshot:      "/samples/808/rs.wav"

    constructor: ->
      this._initAudio()
      this._initSampleManager()
      this._initKit()

    # TODO: should init the global gain level.
    _initAudio: ->
      @audioContext = new webkitAudioContext

      @delayNode = @audioContext.createDelayNode()
      @delayNode.delayTime.value = 0.333

      @feedbackNode = @audioContext.createGainNode()
      @feedbackNode.gain.value = 0.0

      @delayNode.connect(@audioContext.destination)
      @delayNode.connect(@feedbackNode)
      @feedbackNode.connect(@delayNode)

    _initSampleManager: ->
      @sampleManager = new SampleManager(@audioContext)
      @sampleManager.bind("sample:loaded", this._onSampleLoaded)
      @sampleManager.bind("all:loaded", this._onAllLoaded)
      @sampleManager.loadSamples(@samples)

    _onSampleLoaded: (name, data) =>
      console.log("loaded #{name}")

    _onAllLoaded: =>
      this._start()

    _initKit: ->
      instruments = []

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sample: "bass_drum")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sample: "snare_drum")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sample: "closed_hihat")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sample: "open_hihat")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sample: "clap")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sample: "clave")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sample: "cowbell")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sample: "rimshot")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sample: "snare_drum")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sample: "snare_drum")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sample: "snare_drum")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sample: "snare_drum")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sample: "snare_drum")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sample: "snare_drum")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sample: "snare_drum")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sample: "snare_drum")
      instruments.push(instrument)

      @kit = new Kit(instruments)

      kitViewController    = new KitViewController(title: "Kit", kit: @kit)
      navigationView       = new Backbone.View(el: $("#main"))
      navigationController = new Spleen.NavigationController(view: navigationView, rootViewController: kitViewController)

    _playNote: (sample, note) ->
      gain = note.get("gain")

      # Don't play it if we can't hear it.
      return if gain == 0.0

      source            = @audioContext.createBufferSource()
      source.buffer     = @sampleManager.get(sample)
      source.gain.value = Math.log(gain + 1) / Math.log(2)

      source.connect(@audioContext.destination)
      source.connect(@feedbackNode)
      source.noteOn(@currentTime + 0.1)

    _start: ->
      index = 0
      note = null

      @currentTime = @audioContext.currentTime

      playNextNote = =>
        _(@kit.models).each (instrument) =>
          note   = instrument.get("pattern").models[index]
          sample = instrument.get("sample")
          note.set(active: true)
          this._playNote(sample, note)

        index++
        index = 0 if index >= 16

      setInterval(playNextNote, 450)
