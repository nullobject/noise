define ["models/sound"], (Sound) ->
  class SoundManager extends Backbone.Collection
    model: Sound

    constructor: (options) ->
      super(options)
      @audioContext = options["audioContext"]

    loadSounds: (map) ->
      @remaining = 0
      for id, url of map
        this.loadSound(id, url)

    loadSound: (id, url) ->
      @remaining++
      sound = new Sound(id: id, url: url)
      request = new XMLHttpRequest()
      request.open("GET", url, true)
      request.responseType = "arraybuffer"
      request.onload = => this._onSoundLoaded(sound, request.response)
      request.send()

    _onSoundLoaded: (sound, data) =>
      @remaining--
      sound.set(buffer: @audioContext.createBuffer(data, false))
      this.add(sound)
      this.trigger("all:loaded") if @remaining == 0
