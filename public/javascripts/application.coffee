define ["sound_manager", "models/instrument", "models/kit", "controllers/kit_view_controller"], (SoundManager, Instrument, Kit, KitViewController) ->
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

    _initAudio: ->
      @audioContext = new webkitAudioContext

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
      this._initKit()
      this._start()

    _initKit: ->
      instruments = []

      instruments.push(new Instrument(sound: @soundManager.get("bass_drum")))
      instruments.push(new Instrument(sound: @soundManager.get("snare_drum")))
      instruments.push(new Instrument(sound: @soundManager.get("closed_hihat")))
      instruments.push(new Instrument(sound: @soundManager.get("open_hihat")))
      instruments.push(new Instrument(sound: @soundManager.get("clap")))
      instruments.push(new Instrument(sound: @soundManager.get("clave")))
      instruments.push(new Instrument(sound: @soundManager.get("cowbell")))
      instruments.push(new Instrument(sound: @soundManager.get("rimshot")))
      instruments.push(new Instrument(sound: @soundManager.get("snare_drum")))
      instruments.push(new Instrument(sound: @soundManager.get("snare_drum")))
      instruments.push(new Instrument(sound: @soundManager.get("snare_drum")))
      instruments.push(new Instrument(sound: @soundManager.get("snare_drum")))
      instruments.push(new Instrument(sound: @soundManager.get("snare_drum")))
      instruments.push(new Instrument(sound: @soundManager.get("snare_drum")))
      instruments.push(new Instrument(sound: @soundManager.get("snare_drum")))
      instruments.push(new Instrument(sound: @soundManager.get("snare_drum")))

      @kit = new Kit(instruments)

      kitViewController    = new KitViewController(kit: @kit)
      navigationView       = new Backbone.View(el: $("#main"))
      navigationController = new Spleen.NavigationController(rootViewController: kitViewController, view: navigationView)

    _start: ->
      setInterval(this._tick, 450)

    _tick: =>
      currentTime = @audioContext.currentTime
      @kit.each (instrument) ->
        instrument.tick(currentTime)
