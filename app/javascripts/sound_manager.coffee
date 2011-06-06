define ["models/sound"], (Sound) ->
  class SoundManager
    @instance: null

    # Returns an instance of the sound manager.
    @getInstance: ->
      @instance ||= new SoundManager

    # Returns the sounds.
    getSounds: -> @sounds

    constructor: ->
      _(this).extend(Backbone.Events)
      @audioContext = new webkitAudioContext
      @sounds = new Backbone.Collection([], {model: Sound})
      @remaining = 0

    # Returns the audio context.
    getAudioContext: -> @audioContext

    # Returns the sound with the given ID.
    get: (id) -> @sounds.get(id)

    # Loads the sound with the given ID from the given URL.
    loadSound: (id, url) ->
      @remaining++
      sound = new Sound({id: id, url: url}, {sound_manager: this})
      request = new XMLHttpRequest()
      request.open("GET", url, true)
      request.responseType = "arraybuffer"
      request.onload = => this._onSoundLoaded(sound, request.response)
      request.send()

    # Loads the given sounds.
    loadSounds: (map) ->
      for id, url of map
        this.loadSound(id, url)

    _onSoundLoaded: (sound, data) =>
      @remaining--
      sound.set(buffer: @audioContext.createBuffer(data, false))
      @sounds.add(sound)
      this.trigger("all:loaded") if @remaining == 0
