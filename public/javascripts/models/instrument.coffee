define ["models/pattern", "models/note"], (Pattern, Note) ->
  # An instrument represents a pattern and a sound.
  class Instrument extends Backbone.Model
    defaults:
      pattern: null
      sound:   null

    initialize: ->
      @_index = 0
      this._initPattern()

    _initPattern: ->
      notes = _([0..15]).map -> new Note
      this.set(pattern: new Pattern(notes))

    tick: (currentTime) ->
      note = this.get("pattern").models[@_index]

      note.set(active: true)
      this._playNote(currentTime, note)

      @_index++
      @_index = 0 if @_index >= 16

    _playNote: (currentTime, note) ->
      gain = note.get("gain")

      # Don't play it if we can't hear it.
      return if gain == 0.0

      # Create a new source buffer.
      source = window.soundManager.audioContext.createBufferSource()

      # Set the source buffer.
      source.buffer     = this.get("sound").get("buffer")

      # Set the gain to the logarithmic value.
      source.gain.value = Math.log(gain + 1) / Math.log(2)

      # Connect the source buffer to the destination.
      source.connect(window.soundManager.audioContext.destination)

      # Play the note.
      source.noteOn(currentTime + 0.1)
