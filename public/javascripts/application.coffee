define ["sound_manager", "models/note", "models/pattern", "models/instrument", "models/kit", "controllers/kit_view_controller"], (SoundManager, Note, Pattern, Instrument, Kit, KitViewController) ->
  class Application
    sounds:
      bass_drum:    "/sounds/808/bd.wav"
      snare_drum:   "/sounds/808/sd.wav"
      closed_hihat: "/sounds/808/ch.wav"
      open_hihat:   "/sounds/808/oh.wav"
      clap:         "/sounds/808/cp.wav"
      clave:        "/sounds/808/cl.wav"
      cowbell:      "/sounds/808/cb.wav"
      rimshot:      "/sounds/808/rs.wav"

    constructor: ->
      this._initAudio()
      this._initSoundManager()
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

    _initSoundManager: ->
      @soundManager = new SoundManager(audioContext: @audioContext)

      # FIXME: ugly hack.
      window.soundManager = @soundManager

      @soundManager.bind("add", this._onSoundLoaded)
      @soundManager.bind("all:loaded", this._onAllLoaded)
      @soundManager.loadSounds(@sounds)

    _onSoundLoaded: (sound) =>
      console.log("loaded #{sound.id}")

    _onAllLoaded: =>
      this._start()

    _initKit: ->
      instruments = []

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sound: "bass_drum")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sound: "snare_drum")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sound: "closed_hihat")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sound: "open_hihat")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sound: "clap")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sound: "clave")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sound: "cowbell")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sound: "rimshot")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sound: "snare_drum")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sound: "snare_drum")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sound: "snare_drum")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sound: "snare_drum")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sound: "snare_drum")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sound: "snare_drum")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sound: "snare_drum")
      instruments.push(instrument)

      notes = _([0..15]).map => new Note
      pattern = new Pattern(notes)
      instrument = new Instrument(pattern: pattern, sound: "snare_drum")
      instruments.push(instrument)

      @kit = new Kit(instruments)

      kitViewController    = new KitViewController(kit: @kit)
      navigationView       = new Backbone.View(el: $("#main"))
      navigationController = new Spleen.NavigationController(rootViewController: kitViewController, view: navigationView)

    _playNote: (sound, note) ->
      sound = @soundManager.get(sound)
      gain   = note.get("gain")

      # Don't play it if we can't hear it.
      return if gain == 0.0

      source            = @audioContext.createBufferSource()
      source.buffer     = sound.get("buffer")
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
          note  = instrument.get("pattern").models[index]
          sound = instrument.get("sound")
          note.set(active: true)
          this._playNote(sound, note)

        index++
        index = 0 if index >= 16

      setInterval(playNextNote, 450)
