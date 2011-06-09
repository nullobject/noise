define ["models/sound", "models/sound_set"], (Sound, SoundSet) ->
  # The sound manager handles the loading of sounds.
  class SoundManager
    @instance: null

    # Returns an instance of the sound manager.
    @getInstance: ->
      @instance ||= new SoundManager

    # Returns the sounds set with the given ID.
    getSoundSet: (id) -> @soundSets.get(id)

    # Returns the audio context.
    getAudioContext: -> @audioContext

    constructor: ->
      _(this).extend(Backbone.Events)
      @audioContext = new webkitAudioContext
      @soundSets = new Backbone.Collection([], {model: SoundSet})
      @remaining = 0

    # Loads the given sounds.
    loadSounds: (soundSets) ->
      for id, sounds of soundSets
        this.loadSoundSet(id, sounds)

    # Loads the sound set with the given ID and sounds.
    loadSoundSet: (id, sounds) ->
      soundSet = new SoundSet(id: id)

      for id, url of sounds
        sound = this.loadSound(id, url)
        soundSet.add(sound)

      @soundSets.add(soundSet)

    # Loads the sound with the given ID and URL.
    loadSound: (id, url) ->
      @remaining++
      sound = new Sound({id: id, url: url}, {sound_manager: this})
      request = new XMLHttpRequest()
      request.open("GET", url, true)
      request.responseType = "arraybuffer"
      request.onload = => this._onSoundLoaded(sound, request.response)
      request.send()
      sound

    _onSoundLoaded: (sound, data) =>
      @remaining--
      sound.set(buffer: @audioContext.createBuffer(data, false))
      this.trigger("all:loaded") if @remaining == 0
