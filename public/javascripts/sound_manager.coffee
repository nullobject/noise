define ["models/sound"], (Sound) ->
  # Triggers events after each individual sound is loaded and after all
  # sounds are loaded.
  #
  #   soundManager = new SoundManager(context)
  #   soundManager.loadSounds(kick: "/sounds/kick.wav", snare: "/sounds/snare.wav")
  #   buffer = soundManager.get("kick")
  class SoundManager extends Backbone.Collection
    constructor: (@context) ->
      _.extend(this, Backbone.Events)
      @sounds = new Backbone.Collection(model: Sound)
      @remaining = 0

    get: (id) ->
      @sounds.get(id)

    loadSounds: (map) ->
      for id, url of map
        this.loadSound(id, url)

    loadSound: (id, url) ->
      @remaining++
      request = new XMLHttpRequest()
      request.open("GET", url, true)
      request.responseType = "arraybuffer"
      request.onload = => this._onSoundLoaded(id, request.response)
      request.send()

    _onSoundLoaded: (id, data) =>
      @remaining--
      buffer = @context.createBuffer(data, false)
      @sounds.add(id: id, buffer: buffer)
      this.trigger("sound:loaded", id, data)
      this.trigger("all:loaded") if @remaining == 0
