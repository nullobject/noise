define ->
  # An instrument represents a sound collection of sounds.
  class Instrument extends Backbone.Model
    getSound: -> this.get("sound")

    playNote: (currentTime, note = "C", gain = 1.0) ->
      # Don't play it if we can't hear it.
      return if gain <= 0.0

#       # Create a new source buffer.
#       source = window.soundManager.audioContext.createBufferSource()
#
#       # Set the source buffer.
#       source.buffer = this.getSound().getBuffer()
#
#       # Set the gain to the logarithmic value.
#       source.gain.value = Math.log(gain + 1) / Math.log(2)
#
#       # Connect the source buffer to the destination.
#       source.connect(window.soundManager.audioContext.destination)
#
#       # Play the note.
#       source.noteOn(currentTime + 0.1)
