define ->
  class Sound extends Backbone.Model
    defaults:
      buffer: null
      url:    null

    # Returns the buffer.
    getBuffer: -> this.get("buffer")

    # Returns the URL.
    getUrl: -> this.get("url")

    # Returns the ID.
    toString: -> @id.toString()

    # Plays the sound at the given time and gain.
    play: (time, gain) ->
      # Don't play it if we can't hear it.
      return if gain <= 0.0

      # Create a new source buffer.
      source = SoundManager.getInstance().getAudioContext().createBufferSource()

      # Set the source buffer.
      source.buffer = this.getBuffer()

      # Set the gain to the logarithmic value.
      source.gain.value = Math.log(gain + 1) / Math.log(2)

      # Connect the source buffer to the destination.
      source.connect(SoundManager.getInstance().getAudioContext().destination)

      # Play the note.
      source.noteOn(time)
