define ["sound_manager", "models/generative_sequencer", "models/instrument", "models/kit", "controllers/kit_view_controller"], (SoundManager, GenerativeSequencer, Instrument, Kit, KitViewController) ->
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
      this._initSoundManager()

    _initSoundManager: ->
      @soundManager = new SoundManager.getInstance()
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

      @kit = new Kit

      @kit.add(new GenerativeSequencer(instrument: new Instrument(sound: @soundManager.get("bass_drum"))))

      kitViewController    = new KitViewController(kit: @kit)
      navigationView       = new Backbone.View(el: $("#main"))
      navigationController = new Spleen.NavigationController(rootViewController: kitViewController, view: navigationView)

    _start: ->
      setInterval(this._tick, 450)

    _tick: =>
      time = @soundManager.getAudioContext().currentTime + 0.1
      @kit.each (instrument) -> instrument.tick(time)
